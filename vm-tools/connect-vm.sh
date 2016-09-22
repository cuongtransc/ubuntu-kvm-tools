#!/bin/bash

################### Config ###################
BASE_DIR=$(dirname ${0})
BASE_DIR=$(readlink -f "${BASE_DIR}")

# default configs
SSH_DIR=~/.ssh
SSH_KEY=vm_default_ssh_key
USER_DEFAULT=ubuntu

# get custom configs
if [ -f ${BASE_DIR}/config/config.sh ]; then
    source ${BASE_DIR}/config/config.sh
fi

################### Usage ###################
# get guest ip address
# http://stackoverflow.com/a/19140005/1316860

if [ -z "$1" ]; then
    echo "Usage: ./connect-vm.sh <vm-name>"
    exit 1
fi

INSTANCE_NAME=$1

############# Get VM IP address ############
macs=`virsh domiflist ${INSTANCE_NAME} | grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})"`

# get first element
mac="${macs%% *}"
vm_ip=`arp -n -e | grep ${mac} | grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}";`

if [ -z "${vm_ip}" ]; then
    echo "Error: Can't get VM IP Address! Please check VM is running."
    exit 1
fi

############# Connect VM ############
ssh ${USER_DEFAULT}@${vm_ip} -i ${SSH_DIR}/${SSH_KEY}

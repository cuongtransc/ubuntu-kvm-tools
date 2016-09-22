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
    echo "Usage: ./generate-ssh-config.sh <vm-name>"
    exit 1
fi

INSTANCE_NAME=$1

############# Check VM instance exist ############
virsh dominfo ${INSTANCE_NAME} &>/dev/null

if [[ $? != 0 ]]; then
    echo "Error: ${INSTANCE_NAME} don't exist"
    exit 1
fi

############# Get VM IP address ############
macs=`virsh domiflist ${INSTANCE_NAME} | grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})"`

# get first element
mac="${macs%% *}"
vm_ip=`arp -n -e | grep ${mac} | grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}";`

if [ -z "${vm_ip}" ]; then
    echo "Error: Can't get VM IP Address! Please check VM is running."
    exit 1
fi

############# Generate ssh config #############
grep "Host ${INSTANCE_NAME}" ${SSH_DIR}/config &>/dev/null

if [[ $? == 0 ]]; then
    echo "ssh config ${INSTANCE_NAME} existed"
else
    echo "Generate ssh config: ${INSTANCE_NAME}"

    cat >> ${SSH_DIR}/config <<EOF
Host ${INSTANCE_NAME}
    identityfile ${SSH_DIR}/${SSH_KEY}
    hostname ${vm_ip}
    user ${USER_DEFAULT}
    port 22
EOF
    echo "Done!"
fi

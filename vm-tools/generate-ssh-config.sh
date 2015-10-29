#!/bin/bash

# get guest ip address
# http://stackoverflow.com/a/19140005/1316860

if [ -z "$1" ]; then
    echo "Usage: ./generate-ssh-config.sh <domain>"
    exit 1
fi

INSTANCE_NAME=$1

SSH_DIR=~/.ssh
SSH_KEY=olbius_vm_default_ssh_key
SSH_CONFIG=config

USER_DEFAULT=ubuntu

############# check VM instance exist ############
virsh dominfo ${INSTANCE_NAME} &>/dev/null

if [[ $? != 0 ]]; then
    echo "Error: ${INSTANCE_NAME} don't exist"
    exit 1
fi

############# get VM IP address ############
macs=`virsh domiflist ${INSTANCE_NAME} | grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})"`

# get first element
mac="${macs%% *}"
vm_ip=`arp -n -e | grep ${mac} | grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}";`

if [ -z ${vm_ip} ]; then
    echo "Error: Don't get VM IP address"
    exit 1
fi

############# check config exist #############
grep "Host ${INSTANCE_NAME}" ${SSH_DIR}/${SSH_CONFIG} &>/dev/null

if [[ $? == 0 ]]; then
    echo "ssh config ${INSTANCE_NAME} existed"
else
    echo "Generate ssh config: ${INSTANCE_NAME}"

    cat >> ${SSH_DIR}/${SSH_CONFIG} <<EOF
Host ${INSTANCE_NAME}
    identityfile ${SSH_DIR}/${SSH_KEY}
    hostname ${vm_ip}
    user ${USER_DEFAULT}
    port 22
EOF
    echo "Done!"
fi


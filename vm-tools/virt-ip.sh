#!/bin/bash

################### Config ###################
BASE_DIR=$(dirname ${0})
BASE_DIR=$(readlink -f "${BASE_DIR}")

# get custom configs
if [ -f ${BASE_DIR}/config/config.sh ]; then
    source ${BASE_DIR}/config/config.sh
fi

################### Usage ###################
# get guest ip address
# http://stackoverflow.com/a/19140005/1316860

if [ -z "$1" ]; then
    echo "Usage: ./virt-ip.sh <vm-name>"
    exit 1
fi

INSTANCE_NAME=$1

macs=`virsh domiflist ${INSTANCE_NAME} | grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})"`

for mac in ${macs} ; do
    arp -n -e | grep ${mac} | grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}";
done

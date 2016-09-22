#!/bin/bash
set -e

################### Config ###################
BASE_DIR=$(dirname ${0})
BASE_DIR=$(readlink -f "${BASE_DIR}")

# default configs
PATH_LIBVIRT='/var/lib/libvirt'
PATH_LIBVIRT_IMG=${PATH_LIBVIRT}/images

# get custom configs
if [ -f ${BASE_DIR}/config/config.sh ]; then
    source ${BASE_DIR}/config/config.sh
fi

################### Usage ###################
if [ -z "$1" ]; then
    echo "Usage: ./delete-vm.sh <vm-name>"
    exit 1
fi

INSTANCE_NAME=$1

# check instance exist
if [ ! -e ${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img ]; then
    echo "${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img don't exist"
    echo "$INSTANCE_NAME don't exist"
    exit 1
fi

echo "Step 1: Shutdown VM"
virsh destroy ${INSTANCE_NAME}

echo "Step 2: Undefine VM"
virsh undefine ${INSTANCE_NAME}

echo "Step 3: Remove disk"
sudo rm ${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img

echo "Done!"

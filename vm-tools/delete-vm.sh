#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./delete-vm.sh <domain>"
    exit 1
fi

PATH_LIBVIRT='/var/lib/libvirt'
PATH_LIBVIRT_IMG=${PATH_LIBVIRT}/images

INSTANCE_NAME=$1

# check instance exist
if [ ! -e ${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img ]; then
    echo "${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img don't exist"
    echo "$INSTANCE_NAME don't exist"
    exit 1
fi

echo "step 1: shutdown vm"
virsh destroy ${INSTANCE_NAME}

echo "step 2: undefine vm"
virsh undefine ${INSTANCE_NAME}

echo "step 3: remove disk"
sudo rm ${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img

echo "done!"


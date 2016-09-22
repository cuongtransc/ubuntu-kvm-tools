#!/bin/bash
set -e

################### Config ###################
BASE_DIR=$(dirname ${0})
BASE_DIR=$(readlink -f "${BASE_DIR}")

# default configs
PATH_LIBVIRT='/var/lib/libvirt'
PATH_LIBVIRT_IMG=${PATH_LIBVIRT}/images

BASE_IMG='ubuntu-1604-custom.img'

# get custom configs
if [ -f ${BASE_DIR}/config/config.sh ]; then
    source ${BASE_DIR}/config/config.sh
fi

################### Usage ###################
if [ -z "$1" ]; then
    echo "Usage: ./create-vm.sh <vm-name>"
    exit 1
fi

INSTANCE_NAME=$1

# check instance exists
if [ -e ${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img ]; then
    echo "${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img exists"
    exit 1
fi

echo "Step 1: Create vm disk"
sudo qemu-img create -f qcow2 -b ${PATH_LIBVIRT_IMG}/${BASE_IMG} ${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img

echo "Step 2: Init vm"
virt-install \
    --name=${INSTANCE_NAME} \
    --ram=1024 \
    --vcpus=1 \
    --os-type=linux \
    --os-variant=generic \
    --network bridge=virbr0 \
    --disk path=${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img,format=qcow2,bus=virtio,cache=none \
    --noautoconsole \
    --nographics \
    --import

echo "Done!"


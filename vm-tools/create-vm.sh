#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./create-vm.sh <domain>"
    exit 1
fi


PATH_LIBVIRT='/var/lib/libvirt'
PATH_LIBVIRT_IMG=${PATH_LIBVIRT}/images

BASE_IMG='ubuntu-14.04-server-cloudimg-amd64-disk1.img'

INSTANCE_NAME=$1

# check instance exist
if [ -e ${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img ]; then
    echo "${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img exists"
    exit 1
fi

echo "step 1: create vm disk"
sudo qemu-img create -f qcow2 -b ${PATH_LIBVIRT_IMG}/${BASE_IMG} ${PATH_LIBVIRT_IMG}/${INSTANCE_NAME}.img

echo "step 2: init vm"
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

echo "done!"


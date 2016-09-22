#!/bin/bash

# Create VM
PATH_LIBVIRT='/var/lib/libvirt'
PATH_LIBVIRT_IMG=${PATH_LIBVIRT}/images
BASE_IMG='ubuntu-1604-custom.img'

# Connect VM
SSH_DIR=~/.ssh
SSH_KEY=vm_default_ssh_key
USER_DEFAULT=ubuntu

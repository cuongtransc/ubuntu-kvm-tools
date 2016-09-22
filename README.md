# ubuntu-kvm-tools
Utilities to manage VM by command line.

## Setup ubuntu-kvm-tools
### 1. Install kvm on ubuntu
```sh
# Install kvm, libvirt
sudo apt-get update
sudo apt-get install -y qemu-kvm libvirt-bin

# virt-install is part of the virtinst package.
sudo apt-get install -y virtinst

# Check
sudo service libvirt-bin status

# Add the user to libvirtd group
sudo usermod -a -G libvirtd `whoami`
```

### 2. Clone ubuntu-kvm-tools
```sh
git clone https://github.com/tranhuucuong91/ubuntu-kvm-tools.git
```

```sh
cd ubuntu-kvm-tools/vm-tools

# change config if need
cp config/config.tmpl.sh config/config.sh
```

### 3. Prepare Materials
**1. Base image**

```sh
PATH_LIBVIRT='/var/lib/libvirt'
PATH_LIBVIRT_IMG=${PATH_LIBVIRT}/images
BASE_IMG='ubuntu-1604-custom.img'

sudo mv ${BASE_IMG} ${PATH_LIBVIRT}/images/${BASE_IMG}

sudo ls ${PATH_LIBVIRT}/images/
```

**2. ssh key**
```
vm_default_ssh_key
vm_default_ssh_key.pub
```

## Usage ubuntu-kvm-tools
### Create VM
```sh
./create-vm.sh <vm-name>

# Change hostname
./update-vm-hostname.sh <vm-name>
```

### Upgrade RAM, CPU
```sh
# Step 1: Edit virtual machine config
virsh edit <vm-name>

# Step 2: Shutdown and Restart for apply new config
virsh shutdown <vm-name>
virsh start <vm-name>
```

### Connect VM
```sh
./connect-vm.sh <vm-name>
```

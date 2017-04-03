#!/bin/bash

# This script will snapshot off root and also create the recovery clone

# Setup
TIMESTAMP=$(date +%G%m%d%H%M)
rootFS="rpool/ROOT/ubuntu"
rootSnap="${rootFS}@${TIMESTAMP}"
recoveryClone="${rootFS}-recovery"
recoveryMount="/ubuntu-recovery"

echo "Creating snap: ${rootSnap}"
zfs snapshot ${rootSnap}

echo "Destroying old root clone: ${recoveryClone}"
mountpoint -q -- ${recoveryMount} && umount ${recoveryMount}
zfs destroy ${recoveryClone}

echo "Create new root clone: ${rootSnap} -> ${recoveryClone}"
zfs clone ${rootSnap} ${recoveryClone}

echo "Set mountpoint on new root clone: ${recoveryClone}"
zfs set mountpoint=legacy ${recoveryClone}
mount ${recoveryMount}

echo "Update Grub"
update-grub

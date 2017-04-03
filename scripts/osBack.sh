#!/bin/bash

# This script will snapshot off root and also create the recovery clone

# Setup
day=$(date +%G%m%d%H%M)
rootPool="rpool"
copies=7

for vol in $(zfs list -rH rpool/var | awk '{ print $1 }')
do
	echo "Managing snapshots for: ${vol}"
	echo "	Creating snapshot: ${vol}@${day}"
	zfs snapshot ${vol}@${day}

	count=0
	for snap in $(zfs list -d 1 -Hr -t snapshot ${vol} | awk '{ print $1}' | sort -r)
	do
		if [ ${count} -lt ${copies} ]; then
			echo "	Keeping snapshot: ${snap}"
		else
			echo "	Destroying snapshot: ${snap}"
			zfs destroy ${snap}
		fi

		((count++))
	done
done

exit 1

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

#!/bin/bash

# Smo zagnali kot root?
if [ "$EUID" -ne 0 ]
	then echo "Zaženi kot root"
 	exit
fi

#Preverimo disk 
if ! ([ $# -gt 0 ] && [ $# -lt 2 ]); then
	echo "Posredujem natanko 1 parameter (disk ki ga boš formatiral)"
	exit
fi

# Disk, ki ga particioniramo
disk=$1

# Parted
parted -s $disk \
  mklabel gpt \
  mkpart primary ext4 1MiB 100%

# Formatiramo kot ext4
mkfs.ext4 ${disk}1

mkdir -p /mnt/disk
mount ${disk}1 /mnt/disk
uuid=$(blkid -s UUID -o value ${disk}1)
echo "UUID=$uuid /mnt/disk ext4 defaults 0 2" >> /etc/fstab

echo "Particioniranje in priklapljanje končano."


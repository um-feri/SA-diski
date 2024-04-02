#!/bin/bash

# Smo zagnali kot root?
if [ "$EUID" -ne 0 ]
	then echo "Zaženi kot root"
 	exit
fi


if ! ([ $# -gt 0 ] && [ $# -lt 3 ]); then
	echo "Posreduj natanko 2 parametra (diska ki ju boš uporabil)"
	exit
fi
disk1=$1
disk2=$2

# Parted
parted -s $disk1 \
  mklabel gpt \
  mkpart primary 0% 100%
  
parted -s $disk2 \
  mklabel gpt \
  mkpart primary 0% 100%
  
sleep 2
    
mdadm --create --verbose /dev/md1 --level=mirror --raid-devices=2 ${disk1}1 ${disk2}1


sudo mkfs.ext4 /dev/md1


sudo mkdir -p /mnt/raid1
sudo mount /dev/md1 /mnt/raid1

echo "Končal in ustvaril RAID 1 na dveh particijah celotnega diska"


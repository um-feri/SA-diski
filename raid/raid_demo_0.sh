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

    
mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 $disk1 $disk2


sudo mkfs.ext4 /dev/md0


sudo mkdir -p /mnt/raid0
sudo mount /dev/md0 /mnt/raid0

echo "Končal in ustvaril RAID 0 na dveh diskih"


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

# Disk ki ga particioniramo
disk=$1

# Parted
parted -s $disk \
  mklabel gpt \
  mkpart primary 1MiB 25MiB \
  mkpart primary 25MiB -- -1

sleep 2
# Formatiramo kot ext4
mkfs.ext4 ${disk}1
mkfs.ext4 ${disk}2

echo "Particioniranje končano."


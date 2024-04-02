#!/bin/bash

# Smo zagnali kot root?
if [ "$EUID" -ne 0 ]
	then echo "Zaženi kot root"
 	exit
fi


if ! ([ $# -gt 0 ] && [ $# -lt 2 ]); then
	echo "Posreduj natanko 1 parameter (polje ki ga boš odstranil)"
	exit
fi
raid_polje=$1

if grep -qs ${raid_polje} /proc/mounts; then
	umount $raid_polje
fi

mdadm --stop ${raid_polje}

cat /proc/mdstat

dd if=/dev/zero of=/dev/sdb bs=1M
dd if=/dev/zero of=/dev/sdc bs=1M

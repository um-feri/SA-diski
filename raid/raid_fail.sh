#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  echo "Zaženi kot root"
  exit 1
fi

if ! ([ $# -gt 0 ] && [ $# -lt 4 ]); then
	echo "Posreduj natanko 3 parametra (diska ki ju boš uporabil)"
	exit
fi

raid_polje=$1
fail_disk=$2
replace_disk=$3

echo "Simuliramo uničenje RAID polja ..."

# Označimo disk kot fail
mdadm --manage "$raid_polje" --fail "$fail_disk"

# Trenutni status
echo "Status RAID polja:"
mdadm --detail "$raid_polje"

echo "Skušajmo popravit RAID polje ..."

# Odstranimo pokvarjen disk iz polja
mdadm --manage "$raid_polje" --remove "$fail_disk"

# Dodamo menjavo v polje
mdadm --manage "$raid_polje" --add "$replace_disk"

# Izpišimo status RAID polja
echo "Status RAID polja:"
mdadm --detail "$raid_polje"

echo "Končali s simuliranjem okvare RAID polja."


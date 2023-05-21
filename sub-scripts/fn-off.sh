#!/bin/bash

# Lenovo 100w gen3 
# Disable fn lock even before altering BIOS
# Put this file in /etc/init.d/ folder with exec permissions

echo 0 > /sys/devices/pci0000\:00/0000\:00\:14.3/PNP0C09\:00/VPC2004\:00/fn_lock

# and put this scrip in /usr/lib/systemd/system-sleep/

#if [ "${1}" == "post" ]; then
#	echo 0 > /sys/devices/pci0000\:00/0000\:00\:14.3/PNP0C09\:00/VPC2004\:00/fn_lock
#fi


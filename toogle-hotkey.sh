#!/bin/bash

TOOGLE=$1

case $1 in

  0)
    echo "Disabling Hotkeys"
    ;;

  1)
    echo "Enabling Hotkeys"
    ;;

  *)
	  echo "Wrong argument. Only 0 (disable) or 1 (enable) are permited."
	  exit 1
    ;;
esac

echo $TOOGLE > /sys/devices/pci0000\:00/0000\:00\:14.3/PNP0C09\:00/VPC2004\:00/fn_lock

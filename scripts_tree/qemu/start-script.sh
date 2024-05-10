#!/bin/zsh

qemu-system-x86_64 \
  -machine accel=hvf \
  -cpu Nehalem \
  -smp 2 \
  -hda ubuntu-22.04.1-live-server-amd64.qcow2 \
  -cdrom ubuntu-22.04.1-live-server-amd64.iso \
  -m 2G \
  -vga std \
  -usb \
  -device usb-tablet \
  -display default,show-cursor=on

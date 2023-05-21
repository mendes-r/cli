#!/bin/bash

PKG="apt-get"
PRG="vim git tmux neomutt tree screenfetch trace-cmd kernelshark btop bat pandoc nmap proxychains4 openvpn openssh-server"

# install base programs

$PKG update && $PKG upgrade

for program in $PRG; do
	sudo $PKG $program -y
done

# install vim plugins
# vundle
# nerdtree
# airline

# add configuration files
# from cli repo

# chang swapfile size permantly
# calculate best dimension
# sudo swapoff -a
# sudo fallocate -l 6G /swapfile
# sudo chmod 600 /swapfile
# sudo mkswap /swapfile
# sudo swapon /swapfile
# swapon --show
# xed admin:///etc/fstab
# /swapfile swap swap defaults 0 0



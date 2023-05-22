#!/bin/bash

OS
PKG
BASE="tree curl wget openssh-server bat gcc"
SLIM="neovim python3-neovim nmap wireshark python3-pip"
FAT="kernelshark trace-cmd"

function get-os() {
	OS=$(cat /etc/os-release | grep '^ID=*' | cut -d = -f 2 | tr a-z A-Z)  
}

function get-pkg() {
	case $OS in
		FEDORA) PKG=dnf;;
		UBUNTU) PKG=apt-get;;
		*)PKG=error;;
	esac
}

function spinout() {
	PID=$1
	i=1
	sp="/-\|"
	echo -n ' '
	while [ -d /proc/$PID ]; do
  		printf "\b${sp:i++%${#sp}:1}"
		sleep 0.2
	done
}

function install() {
	for program in $PRG; do
		echo "start $program instalation ..."
		$PKG $program -y &
		spinout $!
	done
}

clear

mkdir -p ~/Developer

get-os
echo "Let's personalize this $OS distro"
get-pkg
echo "We will be using the $PKG package manager"

while true; do
	read -p "SLIM or FAT installation? [Ss/Ff] " -n 1 answer
	case $answer in
		[Ss]*) echo -e "\nSLIM installation"; break;;
		[Ff]*) echo -e "\nFAT installation"; break;;	
		*) echo "";;
	esac
done

# $PKG update -y && $PKG upgrade -y

sleep 5 &
spinout $!

clear

#!/bin/bash

OS="FEDORA"
PKG="dnf"
JOB=""
BASE="tree curl wget openssh-server bat gcc btop"
SLIM="neovim python3-neovim nmap wireshark python3-pip"
FAT="kernelshark trace-cmd"
INSTALL=""
#proxychain4 openvpn tmux latex 

# Ansi escape codes
C_B_CYAN="\u001b[46;1m" 
C_RESET="\u001b[0m"

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
	JOB=$1
	i=1
	sp="/-\|"
	echo -n ' '
	while [ -d /proc/$JOB ]; do
  		printf "\b${sp:i++%${#sp}:1}"
		sleep 0.2
	done
	JOB=""
}

function install() {
	for program in $INSTALL; do
		echo "start $program instalation ..."
		$PKG $program -y &
		spinout $!
	done
}

function hello-diag() {
	clear
	echo ""
	echo -e "\tLet's personalize your $C_B_CYAN$OS$C_RESET"
	echo -e "\tWe will be using the $C_B_CYAN$PKG$C_RESET package manager"
	echo ""
}

function install-mode-diag() {
	while true; do
		read -p $'\tSLIM or FAT installation? [Ss/Ff] ' -n 1 answer
		case $answer in
			[Ss]*) echo -e "\n\tSLIM installation"; INSTALL="$BASE $SLIM"; break;;
			[Ff]*) echo -e "\n\tFAT installation"; INSTALL="$BASE $SLIM $FAT"; break;;	
			[Qq]*) echo ""; exit 0;;
			*) echo "";;
		esac
	done
	echo ""
}

function update-pkg() {
	echo -e "\tUpdating package manager"
	echo -en "\tWaiting ... "
	sleep 1 
	$PKG update -y >/dev/null 2>&1 & disown
	spinout $!
	echo ""
	echo -en "\tUpgrading ... "
	$PKG upgrade -y >/dev/null 2>&1 & disown
	spinout $!
}

trap "{ kill -9 $JOB; exit 255 }" SIGINT

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

clear

get-os
get-pkg

hello-diag
#update-pkg
install-mode-diag

echo $INSTALL
mkdir -p ~/Developer

sleep 5 &
spinout $!
clear



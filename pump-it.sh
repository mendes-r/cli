#!/bin/bash

OS="FEDORA"
PKG="dnf"
JOB=""
BASE="tree curl wget openssh-server bat gcc btop"
SLIM="neovim python3-neovim nmap wireshark python3-pip"
FAT="kernelshark trace-cmd"
INSTALL=""
#proxychain4 openvpn tmux latex 

ANSWER=""

# Ansi escape codes
C_BG="\u001b[46;1m" 
C_RESET="\u001b[0m"

# Frame
F_MARGIN=5

function echo-line() {
	# left margin
	for (( i=0; i<$F_MARGIN; i++ ))
	do
		echo -n " "
	done
	
	# print content
	echo -en "$C_BG"
	STRING_SIZE=$(echo $1 | wc -c)	
	FILL_SIZE=$((COLUMNS-STRING_SIZE-F_MARGIN-F_MARGIN)) 
	echo -en $1
	for (( i=0; i<$FILL_SIZE; i++ ))
	do
		echo -n " "
	done
	echo -e "$C_RESET"
}

function read-line() {
	# left margin
	for (( i=0; i<$F_MARGIN; i++ ))
	do
		echo -n " "
	done
	
	# print content
	echo -en "$C_BG"
	read -p "$1" -n1 ANSWER
	STRING_SIZE=$(echo $1 | wc -c)	
	FILL_SIZE=$((COLUMNS-STRING_SIZE-F_MARGIN-F_MARGIN-2)) 
	for (( i=0; i<$FILL_SIZE; i++ ))
	do
		echo -n " "
	done
	echo -e "$C_RESET"
}

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
	echo-line "Let's personalize your $OS"
	echo-line "We will be using the $PKG package manager"
}

function install-mode-diag() {
	echo-line ""	
	while true; do
		read-line "SLIM or FAT installation? [Ss/Ff] "
		case $ANSWER in
			[Ss]*) echo-line; echo-line "SLIM installation"; INSTALL="$BASE $SLIM"; break;;
			[Ff]*) echo-line; echo-line "FAT installation"; INSTALL="$BASE $SLIM $FAT"; break;;	
			[Qq]*) echo-line; echo-line ""; exit 0;;
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



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
M_SLIM="SLIM"
M_FAT="FAT"

# Ansi escape codes
C_BG="\u001b[40;1m" 
C_RESET="\u001b[0m"

# Frame
F_MARGIN=5
F_PADDING=5

function echo-line() {
	# left margin
	for (( i=0; i<$F_MARGIN; i++ ))
	do
		echo -n " "
	done
	
	# print content
	echo -en "$C_BG"
	for (( i=0; i<$F_PADDING; i++ ))
	do
		echo -n " "
	done
	STRING_SIZE=$(echo $1 | wc -c)	
	FILL_SIZE=$((COLUMNS-STRING_SIZE-F_MARGIN-F_MARGIN-F_PADDING)) 
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
	echo-line ""
	echo-line "Let's personalize your $OS"
	echo-line "We will be using the $PKG package manager"
}

function flip-mode() {
	if [[ "$M_SLIM" == "SLIM" ]]; then
		M_SLIM="[SLIM]"
		M_FAT="FAT"
	else
		M_SLIM="SLIM"
		M_FAT="[FAT]"
	fi
}

function mode() {
	escape_char=$(printf "\u1b")
	flip-mode
		echo-line ""
		echo-line "Select an installation mode... 'q' to quit."
		echo-line ""
		tput sc # save cursor positon
	while true; do
		echo-line "$M_SLIM"
		echo-line "$M_FAT"
		echo-line ""
		read -rsn1 mode # get 1 character
		if [[ $mode == $escape_char ]]; then
			read -rsn2 mode # read 2 more chars
		fi
		case $mode in
    			'q') clear; exit 0;;
	   	 	'[A') flip-mode;;
    			'[B') flip-mode;;
			'') break;;
    			*) >&2;;
		esac
		tput rc # return to saved cursor position
		tput ed # clear screen bellow cursor
	done

	if [[ $M_SLIM == "[SLIM]" ]]; then
		INSTALL="$BASE $SLIM"
	else
		INSTALL="$BASE $SLIM $FAT"
	fi
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


trap "{ kill -9 $JOB; exit 1 }" SIGINT

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

clear

get-os
get-pkg


hello-diag

echo-line ""
echo-line "//////////////////////////////////////////"

#update-pkg
mode

echo $INSTALL
mkdir -p ~/Developer

sleep 5 &
spinout $!
clear



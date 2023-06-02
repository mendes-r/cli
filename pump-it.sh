#!/bin/bash

OS="FEDORA"
PKG="dnf"
JOB=""
BASE="tree curl wget openssh-server bat gcc btop tor tmux"
SLIM="neovim python3-neovim nmap wireshark proxychains-ng"
FAT="kernelshark trace-cmd openvpn python3-pip texmaker"
INSTALL=""

ANSWER=""
M_INDEX=1

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
	if [[ $2 != n ]]; then echo -en "$C_BG"; fi
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
	if [[ $2 != n ]]; then echo -en "$C_BG"; fi
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
	while [ -d /proc/$JOB ]; do
		printf "\b${sp:i++%${#sp}:1}"
		sleep 0.2
	done
	JOB=""
	echo ""
}

function install() {
	echo ""
	for program in $INSTALL; do
		echo-line "Start $program instalation ..." n
		$PKG $program -y >/dev/null 2>&1 & disown
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

function print-mode() {
	case $M_INDEX in
		1)
			echo-line "[BASE]"
			echo-line "SLIM"
			echo-line "FAT"
			INSTALL="$BASE"
			;;
		2)
			echo-line "BASE"
			echo-line "[SLIM]"
			echo-line "FAT"
			INSTALL="$BASE $SLIM"
			;;
		3)
			echo-line "BASE"
			echo-line "SLIM"
			echo-line "[FAT]"
			INSTALL="$BASE $SLIM $FAT"
			;;
	esac
}

function index-plus() {
	if [[ $M_INDEX == 3 ]]; then 
		M_INDEX=1; 
	else
		M_INDEX=$(($M_INDEX+1))
	fi
}

function index-minus() {
	if [[ $M_INDEX == 1 ]]; then 
		M_INDEX=3; 
	else
		M_INDEX=$(($M_INDEX-1))
	fi
}

function mode() {
	escape_char=$(printf "\u1b")
	echo-line ""
	echo-line "Select an installation mode... 'q' to quit."
	echo-line ""
	tput sc # save cursor positon
	while true; do
		print-mode
		echo-line ""
		echo ""
		echo ""
		echo-line "PACKAGES:" n
		echo-line "$INSTALL" n
		echo ""
		echo ""
		read -rsn1 mode # get 1 character
		if [[ $mode == $escape_char ]]; then
			read -rsn2 mode # read 2 more chars
		fi
		case $mode in
    			'q') clear; exit 0;;
	   	 	'[A') index-minus;;
    			'[B') index-plus;;
			'') break;;
    			*) >&2;;
		esac
		tput rc # return to saved cursor position
		tput ed # clear screen bellow cursor
	done


}

function update-pkg() {
	echo ""
	echo-line "Updating package manager" n
	echo-line "Waiting ... " n
	sleep 1 
	$PKG update -y >/dev/null 2>&1 & disown
	spinout $!
	echo ""
	echo-line "Upgrading ... " n
	$PKG upgrade -y >/dev/null 2>&1 & disown
	spinout $!
}

function cleanup() {
	kill $JOB
	tput cnorm;
	clear	
}


trap cleanup EXIT 

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

clear

tput civis
get-os
get-pkg
hello-diag
echo-line ""
echo-line "//////////////////////////////////////////"
mode
mkdir -p ~/Developer

echo-line ""
echo-line "//////////////////////////////////////////"
echo-line "Update Package Manager"
echo-line ""
update-pkg

echo-line ""
echo-line "//////////////////////////////////////////"
echo-line "Start Installation"
echo-line ""
install

sleep 5 &
spinout $!

tput cnorm
clear



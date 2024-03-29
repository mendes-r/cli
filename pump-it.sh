#!/bin/bash

# Initial values
OS="FEDORA"
PKG="dnf"

HOME_DIR=$(getent passwd $SUDO_USER | cut -d: -f6)

JOB=""
BASE="tree git curl wget openssh-server bat gcc btop tor tmux meld"
SLIM="neovim python3-neovim nmap wireshark proxychains-ng helix"
FAT="kernelshark trace-cmd openvpn python3-pip python-venv texmaker xxd"

# Modes index 1=BASE, 2=SLIM, 3=FAT
INSTALL=""
M_INDEX=1
ELAPSE_TIME=""

# Ansi escape codes
C_BG="\u001b[40;1m" # dark-gray
C_RESET="\u001b[0m"

# Frame
F_MARGIN=5
F_PADDING=5

SEP="//////////////////////////////////////////"

# Error log file
LOG="install-errors.log"

function conf-files() {
	case $1 in
		proxychains-ng) 
			echo-line "Adding config files for $1 to $HOME_DIR..." n
			sudo cp ./config-files/proxychains4.conf /etc/proxychains.conf
			check $?
			;;
		openssh-server)
			echo-line "Adding config files for $1 to $HOME_DIR..." n
			cp ./config-files/sshd_config /etc/ssh/sshd_config
			check $?
			;;
		git)
			echo-line "Adding config files for $1 to $HOME_DIR..." n
			cp ./config-files/.gitconfig $HOME_DIR/.gitconfig
			check $?
			;;
		tmux)
			echo-line "Adding config files for $1 to $HOME_DIR..." n
			cp ./config-files/.tmux.conf $HOME_DIR/.tmux.conf
			check $?
			;;
    neovim)
			echo-line "Adding config files for $1 to $HOME_DIR..." n
      if [[ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]]
      then
        echo-line "Installing vim-plug" n
        curl -fLos "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null
      fi
      mkdir -p $HOME_DIR/.config/nvim
			cp ./config-files/init.vim $HOME_DIR/.config/nvim/
			check $?
			;;
		*)return 0;;

	esac
}

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
	start=$(date +%s)
	JOB=$1
	i=1
	sp="/-\|"
	tput sc # save cursor positon
	while [ -d /proc/$JOB ]; do
		printf "\b${sp:i++%${#sp}:1}"
		sleep 0.2
	done
	tput rc # return to saved cursor position
	tput ed # clear screen bellow cursor
	end=$(date +%s)
	JOB=""
	ELAPSE_TIME=$(($end-$start))
}

function update-pkg() {
	echo ""

	echo-line "Updating package manager..." n
	$PKG update -y >/dev/null 2>> $LOG & PID=$!
	spinout $PID
	wait $PID
	check $?

	echo ""

	echo-line "Upgrading... " n
	$PKG upgrade -y >/dev/null 2>> $LOG & PID=$!
	spinout $PID
	wait $PID
	check $?
}

function install() {
	echo ""
	echo "" > $LOG 
	for program in $INSTALL; do
		echo-line "Start $program instalation..." n
		$PKG install $program -y >/dev/null 2>> $LOG & PID=$!
		tput sc # save cursor positon
		spinout $PID &
		wait $PID
		tput rc # return to saved cursor position
		tput ed # clear screen bellow cursor
		check $?
		conf-files $program
		echo ""
	done
}

function check() {
	if [[ $1 -eq 0 ]]; then 
		echo-line "\U0001f618 successful" n; 
	else 
		echo-line "\U0001f92c failed" n; 
	fi
	echo-line "- exit code: $1" n
	echo-line "- elapsed time: ${ELAPSE_TIME}s" n
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

function select-mode() {
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

function cleanup() {
	kill -9 $JOB > /dev/null 2>&1
	exit
}

trap cleanup EXIT 

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

clear

get-os
get-pkg

hello-diag

echo-line ""
echo-line "$SEP"
select-mode
mkdir -p ~/Developer

echo-line "Adding bashrc to $HOME_DIR and scripts to local bin/..."
cp ./config-files/.bashrc $HOME_DIR/.bashrc
cp ./sub-scripts/bait /usr/local/bin/
check $?
source $HOME_DIR/.bashrc

echo ""

echo-line ""
echo-line "$SEP"
echo-line "Update Package Manager"
echo-line ""
update-pkg

echo ""

echo-line ""
echo-line "$SEP"
echo-line "Start Installation"
echo-line ""
install

echo-line "RESTART the computer!"

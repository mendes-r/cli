#!/bin/bash

DEST=$1

function check() {
	if [ $? == 0 ]
	then
		echo "$1 was successfully copied to $2"
	else
		echo "ERROR, $1 was not copied to $2"
	fi
}

cp ~/.gitconfig $DEST 
check gitconfig $DEST

cp ~/.zshrc $DEST
check zshrc  $DEST

cp ~/.vimrc $DEST
check vimrc $DEST

cp ~/.tmux.conf $DEST
check tmux.config $DEST

cp ~/.bashrc $DEST
check bashrc $DEST



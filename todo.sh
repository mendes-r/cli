#!/bin/bash

# A primitive to-do application
FILE_NAME="todo.md"

window_display () {
  clear
	batcat ~/$FILE_NAME
	echo "i [insert]; r [remove]; v [check]; x [exit]"
  echo ""
	read OPTION ARG1 ARG2
}

input_sanitizer () {
  echo "sanitizing"
}

insert_line () {
  sed -i "$1i [ ] $2" ~/$FILE_NAME 
}

options () {

	case $OPTION in

		"r")
			echo removing
      sed -i $ARG1'd' ~/$FILE_NAME
			;;

    "c")
      echo "(un)checking"
      ;;

    "x")
      echo exiting
      exit 0
      ;;
    
    "i")
      echo inserting
      insert_line $ARG1 $ARG2
      ;;

	esac	
}

while true
do
	window_display
	input_sanitizer
	options
done


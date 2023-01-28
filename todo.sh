#!/bin/bash

# A primitive to-do application
FILE_NAME="todo.md"

window_display () {
  clear
	batcat ~/$FILE_NAME
	echo "i [insert]; b [branch]; r [remove]; v [check]; x [exit]"
  echo ""
	read OPTION ARG1 
}

branch_line () {
  STR=$1
  $1=$(echo $1 | cut -d ' ' -f 1)
  $2=$(echo $STR | cut -d ' ' 2-)
  sed -i "$1i -- [ ] $2" ~/$FILE_NAME 
}

insert_line () {
  echo [ ] $1 >> ~/$FILE_NAME
}

remove_line () {
  if [[ $1 == ?(-)+([[:digit:]]) ]]; then
    sed -i $1'd' ~/$FILE_NAME
  fi
}

options () {

	case $OPTION in

		"r")
			echo removing
      remove_line $ARG1
			;;

    "c")
      echo "(un)checking"
      ;;

    "x")
      exit 0
      ;;
    
    "i")
      echo inserting
      insert_line "${ARG1}" 
      ;;

    "b")
      echo branching
      branch_line "${ARG1}" 
      ;;
    *)
      echo "unknown command"
      ;;

	esac	
}

while true
do
	window_display
	options
done


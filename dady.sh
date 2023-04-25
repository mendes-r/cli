#!/bin/bash
#
#
# This script should not be run directly,
# instead you need to source it from your .bashrc,
# by adding this line:
#   . ~/bin/dady.sh
#

ARG=$1
PDW=$(pwd)
FLAG=1
COUNTER=0
ALL_PARENTS=$(echo $(pwd) | tr / " ")

function go_dady() {

  echo $ALL_PARENTS

  for word in $ALL_PARENTS; do
    if [ "$word" = "$ARG" ]; then FLAG=0; fi
    if [ $FLAG = 0 ]; then ((COUNTER+=1)); fi
    echo $word
  done

  echo $COUNTER

  for ((i = 1 ; i < $COUNTER ; i++ )); do cd ..; done
}

go_dady

# DOESN'T WORK WHEN CALLED FROM .BASHRC

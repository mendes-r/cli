#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

PKG=''
HOME_USER=''

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  args=("$@")

  # check required params and arguments
  [[ ${#args[@]} -lt 2 ]] && die "Missing script argument: package manager, e.g. 'dnf' and user name."
	
  return 0
}

setup_colors
parse_params "$@"

PROGRAMS="git tree curl wget nmap openssh-server sysstat fzf xev"
PKG=$1
HOME_USER=$2

# script logic here

for program in $PROGRAMS; do
  msg "Installing $program..."
  $PKG install $program -y
  msg "${GREEN}$program installed.${NOFORMAT}"
done

msg "Adding config files..."

CONF_PATH=/home/$HOME_USER/
cp ./.gitconfig $CONF_PATH
cp ./.bashrc $CONF_PATH

CONF_PATH=/etc/ssh/
cp ./sshd_config $CONF_PATH

msg "${GREEN}Config files added.${NOFORMAT}"


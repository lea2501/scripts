#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get -y --fix-missing install suckless-tools
$su apt-get -y --fix-missing install stterm
$su apt-get -y --fix-missing install --no-install-recommends cwm
$su apt-get -y --fix-missing install connman connman-ui connman-vpn
cd || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.cwmrc"

# to compile dwm st slstatus etc
#$su apt-get -y --fix-missing install libxft-dev libxinerama-dev
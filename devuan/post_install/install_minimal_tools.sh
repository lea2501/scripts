#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

cloneRepo() {
  mkdir -p ~/src
  cd ~/src || return
  if [ ! -d "$1" ]; then
    git clone "$2"
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

$su apt-get -y --fix-missing install suckless-tools
$su apt-get -y --fix-missing install stterm
$su apt-get -y --fix-missing install --no-install-recommends cwm
cd || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/devuan/.cwmrc"

cloneRepo dwm https://git.suckless.org/dwm
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/devuan/src/dwm/config.h"
$su make clean install

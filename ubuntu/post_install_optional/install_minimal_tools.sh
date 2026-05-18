#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
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
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.cwmrc"

$su apt-get -y --fix-missing install libxft-dev libxinerama-dev
application=dwm
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone https://git.suckless.org/dwm
  cd $application || return
  export compile=true
else
  cd $application || return
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    echo "Need to pull"
    git pull
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application || return
  curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/src/dwm/config.h"
  $su make clean install
fi

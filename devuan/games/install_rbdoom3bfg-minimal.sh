#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y cmake build-essential libsdl2-dev libopenal-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libvulkan-dev libncurses-dev

application=RBDOOM-3-BFG
repository=https://github.com/RobertBeckebans/RBDOOM-3-BFG.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone --recursive $repository
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
    git submodule update --init --recursive
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application/neo || return
  ./cmake-linux-release.sh
  cd ../build || return
  make -j$(nproc)
fi

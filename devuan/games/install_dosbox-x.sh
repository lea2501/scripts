#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y build-essential git pkg-config \
  autoconf autoconf-archive automake bison libtool nasm \
  libncurses-dev libsdl2-dev libsdl2-net-dev libpcap-dev libslirp-dev \
  fluidsynth libfluidsynth-dev libavformat-dev libavcodec-dev libswscale-dev \
  libfreetype-dev libxkbfile-dev libxrandr-dev

application=dosbox-x
repository="https://github.com/joncampbell123/dosbox-x.git"
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
  export compile=true
else
  cd $application || return
  pwd
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    pwd
    echo "Need to pull"
    git pull
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application || return
  ./build-debug-sdl2
fi

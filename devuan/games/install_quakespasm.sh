#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get install -y libsdl2-dev libvorbis-dev libmad0-dev

mkdir -p ~/src
cd ~/src || return
if [ ! -d quakespasm-quakespasm ]; then
  git clone https://git.code.sf.net/p/quakespasm/quakespasm quakespasm-quakespasm
  cd quakespasm-quakespasm || return
else
  cd quakespasm-quakespasm || return
  git pull
fi

cd Quake || return
make DO_USERDIRS=1 USE_SDL2=1

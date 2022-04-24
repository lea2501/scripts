#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

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

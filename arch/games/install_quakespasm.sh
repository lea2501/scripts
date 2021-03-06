#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

application=quakespasm-quakespasm
repository="https://git.code.sf.net/p/quakespasm/quakespasm quakespasm-quakespasm"
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

cd Quake || return
make DO_USERDIRS=1 USE_SDL2=1

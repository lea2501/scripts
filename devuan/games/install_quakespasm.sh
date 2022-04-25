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

application=quakespasm-quakespasm
repository=https://git.code.sf.net/p/quakespasm/quakespasm
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository $application
  cd $application || return
else
  cd $application || return
  git pull
fi

cd ~/src/$application || return
cd Quake || return
make DO_USERDIRS=1 USE_SDL2=1

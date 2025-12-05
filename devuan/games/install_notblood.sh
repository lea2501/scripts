#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

#$su apt-get install -y build-essential nasm libgl1-mesa-dev libglu1-mesa-dev \
#  libsdl1.2-dev libsdl-mixer1.2-dev libsdl2-dev libsdl2-mixer-dev flac libflac-dev \
#  libvorbis-dev libvpx-dev libgtk2.0-dev freepats

$su apt-get install -y git build-essential nasm libsdl2-dev libsdl2-mixer-dev \
  libogg-dev libvorbis-dev libflac-dev libvpx-dev libgtk-3-dev \
  libgl1-mesa-dev libglew-dev

application=NotBlood
repository="https://github.com/clipmove/NotBlood.git"
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
  export compile=true
else
  cd $application || return
  #git pull
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
  make
fi
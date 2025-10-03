#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su pacman -Sy --noconfirm --needed cmake imagemagick
$su pacman -Sy --noconfirm --needed sdl2
$su pacman -Sy --noconfirm --needed fluidsynth glu libmad sdl2_image sdl2_mixer sdl2_net dumb portmidi

application=dsda-doom
repository=https://github.com/kraflab/dsda-doom.git
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
  cd prboom2 || return
  mkdir -p build && cd build
  cmake .. -DCMAKE_BUILD_TYPE=Release
  make
fi

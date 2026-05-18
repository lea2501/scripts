#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su pacman -S --noconfirm gcc make cmake sdl2 libsodium libpng bzip2

application=devilutionX
repository=https://github.com/diasurgical/devilutionX.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
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
  cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
  cmake --build build -j "$(getconf _NPROCESSORS_ONLN)"
fi

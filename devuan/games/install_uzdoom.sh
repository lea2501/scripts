#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y --no-install-recommends build-essential git cmake ninja-build
$su apt-get install -y --no-install-recommends libbz2-dev libomp-dev libopenal-dev libsdl2-dev libvpx-dev libwebp-dev waylandpp-dev

application=UZDoom
repository="https://github.com/UZDoom/UZDoom.git"
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
  mkdir -p build
  cd build || return
  cmake                                \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo  \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -G Ninja                           \
    ..
  cmake --build .
fi
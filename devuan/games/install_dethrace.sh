#!/bin/bash

# fail if any command fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y git cmake ninja-build build-essential libsdl2-dev libgl-dev libgl1-mesa-dev libglu1-mesa-dev libxext-dev

application=dethrace
repository=https://github.com/dethrace-labs/dethrace.git
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
  if [ ! "$LOCAL" = "$REMOTE" ]; then
    echo "Need to pull"
    git pull
    export compile=true
  fi
  git submodule update --init --recursive
  if [ ! -d build ]; then
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application || return
  cmake -B build -GNinja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DDETHRACE_PLATFORM_SDL2=ON
  cmake --build build
fi

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y build-essential cmake git pkg-config \
                 libasound2-dev libpulse-dev libx11-dev libxext-dev libxrandr-dev \
                 libxi-dev libxfixes-dev libxrender-dev libwayland-dev libegl1-mesa-dev \
                 libdrm-dev libgbm-dev libudev-dev libibus-1.0-dev libdbus-1-dev \
                 libjpeg-dev libpng-dev libwebp-dev

application=SDL
repository="https://github.com/libsdl-org/SDL.git"
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
  cmake -B build -DCMAKE_BUILD_TYPE=Release
  cmake --build build
  $su cmake --install build
fi

$su apt-get install -y build-essential libopenal-dev libcurl4-openssl-dev zlib1g-dev libvorbis-dev libogg-dev

application=yquake2remaster
repository="https://github.com/yquake2/yquake2remaster.git"
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
  #export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
  cd ~/src/$application || return
  mkdir build
  cd build
  PKG_CONFIG_PATH=/usr/local/lib/pkgconfig cmake .. -DCMAKE_BUILD_TYPE=Release
  make -j"$(nproc)"
fi

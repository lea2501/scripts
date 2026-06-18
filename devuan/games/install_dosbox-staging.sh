#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y build-essential git cmake ninja-build pkg-config curl zip unzip tar \
  autoconf autoconf-archive automake bison libtool libgl1-mesa-dev libsdl2-dev \
  libx11-dev libxft-dev libxext-dev libwayland-dev libxkbcommon-dev libegl1-mesa-dev \
  libibus-1.0-dev python3-venv

export VCPKG_ROOT="$HOME/src/vcpkg"

application=vcpkg
repository="https://github.com/microsoft/vcpkg.git"
export vcpkg_compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
  export vcpkg_compile=true
else
  cd $application || return
  pwd
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    pwd
    echo "Need to pull"
    git pull
    export vcpkg_compile=true
  fi
fi

if [ "$vcpkg_compile" = "true" ] || [ ! -x "$VCPKG_ROOT/vcpkg" ]; then
  cd "$VCPKG_ROOT" || return
  ./bootstrap-vcpkg.sh -disableMetrics
fi

application=dosbox-staging
repository="https://github.com/dosbox-staging/dosbox-staging.git"
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
  export compile=true
else
  cd $application || return
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

if [ "$vcpkg_compile" = "true" ]; then
  export compile=true
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application || return
  cmake --preset=release-linux-vcpkg
  cmake --build --preset=release-linux-vcpkg -j"$(nproc)"
fi

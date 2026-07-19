#!/bin/bash

# fail if any command fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y --no-install-recommends \
  build-essential git libcurl4-openssl-dev libboost-regex-dev \
  libjsoncpp-dev librhash-dev libtinyxml2-dev libtidy-dev \
  libboost-system-dev libboost-filesystem-dev libboost-program-options-dev \
  libboost-date-time-dev libboost-iostreams-dev cmake pkg-config zlib1g-dev \
  qtwebengine5-dev ninja-build

application=lgogdownloader
repository=https://github.com/Sude-/lgogdownloader.git
compile=

mkdir -p ~/src
cd ~/src

if [ ! -d "$application/.git" ]; then
  git clone "$repository" "$application"
  cd "$application"
  compile=true
else
  cd "$application"
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse '@{u}')
  if [ "$LOCAL" != "$REMOTE" ]; then
    echo "Need to pull"
    git pull --ff-only
    compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cmake -S . -B build \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_QT_GUI=ON \
    -GNinja
  cmake --build build -j "$(getconf _NPROCESSORS_ONLN)"
  $su cmake --install build
else
  echo "$application is already up to date; nothing to compile."
fi

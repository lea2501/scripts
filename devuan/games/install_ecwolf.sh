#!/bin/bash

# Build or update ECWolf from its official GitHub repository on Devuan.
set -e

# Set superuser privileges command if not set.
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  ninja-build \
  libbz2-dev \
  libgtk-3-dev \
  libjpeg-dev \
  libsdl2-dev \
  libsdl2-mixer-dev \
  libsdl2-net-dev \
  zlib1g-dev

application="ECWolf"
repository="https://github.com/ECWolfEngine/ECWolf.git"
source_dir="$HOME/src/$application"
compile=

mkdir -p "$HOME/src"

if [ ! -d "$source_dir/.git" ]; then
  git clone --recursive "$repository" "$source_dir"
  compile=true
else
  cd "$source_dir" || exit 1
  git fetch
  local_revision=$(git rev-parse HEAD)
  remote_revision=$(git rev-parse '@{u}')
  if [ "$local_revision" != "$remote_revision" ]; then
    git pull --ff-only
    compile=true
  fi
  git submodule update --init --recursive
fi

if [ "$compile" = "true" ] || [ ! -x "$source_dir/build/ecwolf" ]; then
  cmake -S "$source_dir" -B "$source_dir/build" \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -G Ninja
  cmake --build "$source_dir/build"
fi

echo "ECWolf is available at: $source_dir/build/ecwolf"

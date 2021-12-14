#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get install -y cmake g++ libsdl2-dev libsodium-dev libpng-dev libbz2-dev

./clone_src.sh devilutionX https://github.com/diasurgical/devilutionX.git
cd ~/src/ || return
cd devilutionX || return
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build -j "$(getconf _NPROCESSORS_ONLN)"
echo "Installing devilutionx... DONE"
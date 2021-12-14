#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su pacman -S --noconfirm gcc make cmake sdl2 libsodium libpng bzip2

./clone_src.sh devilutionX https://github.com/diasurgical/devilutionX.git
cd ~/src/ || return
cd devilutionX || return
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build -j "$(getconf _NPROCESSORS_ONLN)"
echo "Installing devilutionx... DONE"
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get install -y g++ libxi-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev libglew-dev libxrandr-dev build-essential libglm-dev libxxf86vm-dev libfreetype6-dev libfreeimage-dev libtinyxml2-dev pandoc cmake p7zip-full ninja-build curl

application=TrenchBroom
repository="https://github.com/TrenchBroom/TrenchBroom.git"
compile_needed=false
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone --recursive $repository
  cd $application || return
  compile_needed=true
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
    git submodule update --init --recursive
    compile_needed=true
  fi
fi

if [ "$compile_needed" = "true" ]; then
  cd ~/src/$application || return
  mkdir -pv build
  cd build || exit 1
  ../vcpkg/bootstrap-vcpkg.sh
  ../vcpkg/vcpkg install
  cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="/usr" -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake
  ninja
fi

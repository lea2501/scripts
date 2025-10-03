#!/bin/ksh

doas pkg_add autoconf-2.71 gcc-11.2.0p9 gmake sdl2 cairo

application=nodebuilder
repository=https://github.com/7thSamurai/nodebuilder.git
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
  cd build
  cmake .. -DCMAKE_BUILD_TYPE=Release
  gmake -j 4
fi

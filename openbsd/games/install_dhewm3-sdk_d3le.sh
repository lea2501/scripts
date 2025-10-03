#!/bin/ksh

doas pkg_add cmake gmake ninja curl sdl2 openal

application=dhewm3-sdk
repository=https://github.com/dhewm/dhewm3-sdk.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone -b d3le $repository
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
  cmake ../
  gmake -j4
  doas mkdir -p /usr/local/lib/dhewm3/
  doas cp -v d3le.so /usr/local/lib/dhewm3/
fi

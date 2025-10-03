#!/bin/ksh

doas pkg_add autoconf-2.71 gcc-11.2.0p9 gmake

application=ia
repository=https://gitlab.com/martin-tornqvist/ia.git
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
  cmake ../
  gmake ia
  echo "\nNOTE to play the game you need to be on build directory\n"
fi

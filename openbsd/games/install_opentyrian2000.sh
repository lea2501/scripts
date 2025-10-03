#!/bin/bash

doas pkg_add sdl2 sdl2-net gmake unzip curl

application=opentyrian2000
repository="https://github.com/KScl/opentyrian2000.git"
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
  gmake
  # download game data
  if [ ! -d ~/games/opentyrian/data/tyrian2000 ]; then
    mkdir -p ~/games/opentyrian/data
    cd ~/games/opentyrian/data
    curl -OL "https://www.camanis.net/tyrian/tyrian2000.zip"
    unzip tyrian2000.zip
    rm *.zip
  fi
  echo "NOTE: To play run: $ ~/src/opentyrian2000/opentyrian2000 --data=~/games/opentyrian/data/tyrian2000/"
fi

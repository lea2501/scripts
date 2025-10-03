#!/bin/ksh

doas pkg_add sdl2 sdl2-net gmake unzip curl

application=opentyrian
repository="https://github.com/opentyrian/opentyrian.git"
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
  if [ ! -d ~/games/opentyrian/data/tyrian21 ]; then
    mkdir -p ~/games/opentyrian/data
    cd ~/games/opentyrian/data
    curl -OL "https://camanis.net/tyrian/tyrian21.zip"
    unzip tyrian21.zip
    rm *.zip
  fi
  echo "NOTE: To play run: $ ~/src/opentyrian/opentyrian --data=~/games/opentyrian/data/tyrian21/"
fi

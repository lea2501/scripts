#!/bin/ksh

doas pkg_add cmake sdl2 gmake libmad libvorbis

application=ironwail
repository="https://github.com/andrei-drexler/ironwail.git"
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
  cd Quake || return
  gmake DO_USERDIRS=1 USE_SDL2=1
fi

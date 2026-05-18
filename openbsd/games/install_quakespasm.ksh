#!/bin/ksh

application=quakespasm-quakespasm
repository=https://git.code.sf.net/p/quakespasm/quakespasm
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository $application
  cd $application || return
  export compile=true
else
  cd $application || return
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
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

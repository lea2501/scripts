#!/bin/ksh

doas pkg_add gmake sdl2 openal curl

application=yquake2
repository=https://github.com/yquake2/yquake2.git
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
  gmake -j4
  curl --output-dir ~/src/$application/release/baseq2 --create-dirs -OL "https://deponie.yamagi.org/quake2/assets/footsteps.pkz"
  mkdir -p ~/src/$application/release/baseq2/maps/
  cp ~/src/$application/stuff/mapfixes/baseq2/*.ent ~/src/$application/release/baseq2/maps/
fi

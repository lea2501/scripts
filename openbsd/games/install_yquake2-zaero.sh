#!/bin/ksh

doas pkg_add gmake sdl2 openal curl

if [ ! -d ~/src/yquake2/release ]; then
  ./install_yquake2.sh
fi

application=yquake2-zaero
repository=https://github.com/yquake2/zaero.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository $application
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
  if [ -d ~/src/yquake2/release ]; then
	mkdir -p ~/src/yquake2/release/zaero/maps/
	cp ~/src/$application/release/game.so ~/src/yquake2/release/zaero/
	#TODO ent files move
	cp ~/src/$application/stuff/mapfixes/*.ent ~/src/yquake2/release/zaero/maps/
  else
    printf "INFO: Run scripts/openbsd/games/install_yquake2.sh script \n"
    printf "  and move ./release/game.so file to ~/src/yquake2/release/zaero/\n"
    printf "  and move ./stuff/mapfixes/*.ent files to ~/src/yquake2/release/zaero/maps\n"
  fi
fi

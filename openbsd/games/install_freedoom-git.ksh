#!/bin/ksh

doas pkg_add cmake gmake py3-Pillow

print "INFO: Requires deutex as build dependency, installing..."
#./install_deutex.ksh
#print "INFO: Requires deutex as build dependency, installing... DONE"

application=freedoom
repository=https://github.com/freedoom/freedoom.git
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
  gmake -j4 DEUTEX=$HOME/src/deutex/src/deutex
  mkdir -p $HOME/games/doom/maps/iwads/
  mv ./maps/freedm.wad $HOME/games/doom/maps/iwads/freedm-git.wad
  mv ./maps/freedoom1.wad $HOME/games/doom/maps/iwads/freedoom1-git.wad
  mv ./maps/freedoom2.wad $HOME/games/doom/maps/iwads/freedoom2-git.wad
fi

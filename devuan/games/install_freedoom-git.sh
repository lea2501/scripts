#!/bin/bash
# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get install -y build-essential cmake libpillowfight-dev

echo "INFO: Requires deutex as build dependency"
#echo "INFO: Requires deutex as build dependency, installing..."
#./install_deutex.ksh
#echo "INFO: Requires deutex as build dependency, installing... DONE"

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
  make -j4 DEUTEX=$HOME/src/deutex/src/deutex
  mkdir -p $HOME/games/doom/maps/iwads/
  mv ./maps/freedm.wad $HOME/games/doom/maps/iwads/freedm-git.wad
  mv ./maps/freedoom1.wad $HOME/games/doom/maps/iwads/freedoom1-git.wad
  mv ./maps/freedoom2.wad $HOME/games/doom/maps/iwads/freedoom2-git.wad
fi

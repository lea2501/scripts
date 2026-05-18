#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

$su apt-get install -y libsdl2-dev

application=prboom-plus
repository=https://github.com/coelckers/prboom-plus.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
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
  cd prboom2 || return
  cmake .
  make
fi

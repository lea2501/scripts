#!/bin/ksh

doas pkg_add autoconf gcc gmake

application=angband
repository=https://github.com/angband/angband.git
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
  #./autogen.sh
  mkdir build && cd build
  mkdir -p ncursesw/include/ncursesw
  ln -s /usr/include/ncurses.h ncursesw/include/ncursesw
  mkdir -p ncursesw/lib
  ln -s /usr/lib/libncursesw.so* ncursesw/lib
  cmake -DCMAKE_PREFIX_PATH=`pwd`/ncursesw -DSUPPORT_GCU_FRONTEND=ON
  make
fi
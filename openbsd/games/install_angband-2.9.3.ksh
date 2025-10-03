#!/bin/ksh

doas pkg_add gmake

set -x

application=angband
version=2.9.3
game_dir="$HOME/games/roguelikes/${application}/${version}/"
if [ ! -d $game_dir ]; then
  mkdir -p $game_dir
  cd $game_dir
  curl -OL "https://github.com/angband/angband/archive/refs/tags/v${version}.tar.gz"
  tar -xzvf v${version}.tar.gz
  cd ${application}-${version}/
  export CFLAGS=-DL64
  #./configure --with-no-install
  #./configure --prefix "$HOME"/.frogcomposband --with-ncurses-prefix=/usr --without-x --with-no-install CFLAGS="-DSGI -DULTRIX" LIBS=-lncurses
  ./configure --with-ncurses-prefix=/usr --without-x --with-no-install #CFLAGS="-DSGI -DULTRIX" LIBS=-lncurses
  sed -ie 's/timeb.h/time.h/g' src/h-system.h
  gmake clean
  gmake
fi

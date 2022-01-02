#!/bin/ksh

doas pkg_add autoconf gcc gmake
./clone_src.ksh angband https://github.com/angband/angband.git
cd ~/src/angband || return
#./autogen.sh
mkdir build && cd build
mkdir -p ncursesw/include/ncursesw
ln -s /usr/include/ncurses.h ncursesw/include/ncursesw
mkdir -p ncursesw/lib
ln -s /usr/lib/libncursesw.so* ncursesw/lib
cmake -DCMAKE_PREFIX_PATH=`pwd`/ncursesw -DSUPPORT_GCU_FRONTEND=ON
make
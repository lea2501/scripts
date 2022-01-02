#!/bin/ksh

doas pkg_add autoconf gcc gmake
./clone_src.ksh angband https://github.com/angband/angband.git
cd ~/src/angband || return
./autogen.sh
./configure --with-no-install -disable-x11
gmake clean
gmake
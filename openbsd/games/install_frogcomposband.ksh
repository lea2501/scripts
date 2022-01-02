#!/bin/ksh

doas pkg_add autoconf gcc gmake
./clone_src.ksh frogcomposband https://github.com/sulkasormi/frogcomposband.git
cd ~/src/frogcomposband || return
sh autogen.sh
./configure --prefix "$HOME"/.frogcomposband --with-no-install --disable-x11
gmake clean
gmake
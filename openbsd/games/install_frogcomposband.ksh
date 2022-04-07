#!/bin/ksh

doas pkg_add autoconf gcc gmake

application=frogcomposband
repository=https://github.com/sulkasormi/frogcomposband.git
mkdir -p ~/src
cd ~/src || return
if [[ ! -d $application ]]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

cd ~/src/frogcomposband || return
sh autogen.sh
./configure --prefix "$HOME"/.frogcomposband --with-no-install --disable-x11
gmake clean
gmake
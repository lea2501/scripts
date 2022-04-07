#!/bin/ksh

doas pkg_add autoconf gcc gmake

application=angband
repository=https://github.com/angband/angband.git
mkdir -p ~/src
cd ~/src || return
if [[ ! -d $application ]]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

cd ~/src/angband || return
./autogen.sh
./configure --with-no-install -disable-x11
gmake clean
gmake
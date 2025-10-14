#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su pacman -Sy --noconfirm autoconf
$su pacman -Sy --noconfirm gcc
$su pacman -Sy --noconfirm libx11
#gpg --keyserver keys.gnupg.net --recv-keys 702353E0F7E48EDB
#paru ncurses5-compat-libs
#paru libstdc++296 # Edit PKGBUILD manually (https://aur.archlinux.org/packages/libstdc%2B%2B296/)

application=frogcomposband
repository=https://github.com/sulkasormi/frogcomposband.git
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

cd ~/src/frogcomposband || return
sh autogen.sh
./configure --prefix "$HOME"/.frogcomposband --with-no-install
make clean
make

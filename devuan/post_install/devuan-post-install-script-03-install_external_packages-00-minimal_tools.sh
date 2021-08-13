#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cloneRepo() {
  mkdir -p ~/src
  cd ~/src || return
  if [ ! -d "$1" ]; then
    git clone "$2"
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

cloneRepo st https://git.suckless.org/st
cp config.def.h config.def.h.bak
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/st/config.def.h"
sudo apt install -y libxft-dev
sudo make clean install

#cloneRepo dwm https://git.suckless.org/dwm
#cp config.def.h config.def.h.bak
#curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/dwm/config.h"
#mv config.h config.def.h
#sudo make clean install

#cloneRepo slstatus https://git.suckless.org/slstatus
#cp config.def.h config.def.h.bak
#curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/slstatus-git/config.h"
#mv config.h config.def.h
#sudo make clean install

#cloneRepo cwm https://github.com/zenlinux/cwm.git
#make
#sudo make PREFIX=/usr install
cd || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.cwmrc"

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cloneRepo() {
  mkdir -p ~/aur
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

echo "Installing packages 'suckless'..."

cloneRepo st
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/st/config.def.h"
makepkg -sic --noconfirm --skipinteg

cloneRepo dwm
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/aur/dwm/config.h"
#makepkg -sic --noconfirm --skipinteg

cloneRepo cwm
makepkg -sic --noconfirm --skipinteg
cd || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.cwmrc"

echo "Installing packages 'suckless'... DONE"

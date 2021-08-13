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

cloneAurAndCompile() {
  cloneRepo "$1"
  makepkg -sic --noconfirm
}

# browsers
sudo pacman -Sy --noconfirm chromium
cloneAurAndCompile firefox-esr-bin
#cloneAurAndCompile perl-file-rename
#cloneAurAndCompile icecat
#gpg --search-keys 2954CC8585E27A3F
#cloneAurAndCompile librewolf-bin
cloneAurAndCompile surf
cloneAurAndCompile amfora
cloneAurAndCompile bombadillo
cloneAurAndCompile lagrange

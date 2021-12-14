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

echo "Installing AUR package 'paru'..."
cloneRepo paru
makepkg -sic --noconfirm
echo "Installing AUR package 'paru'... DONE"
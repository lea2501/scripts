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
    makepkg -sic --noconfirm
  else
    cd "$1" || return
    git pull
  fi
}

cloneRepo allure-commandline
cloneRepo android-sdk
cloneRepo android-platform
cloneRepo android-sdk-build-tools
cloneRepo android-sdk-platform-tools
cloneRepo android-studio
cloneRepo audacium
cloneRepo bash-git-prompt
cloneRepo bdinfo-git
#cloneRepo bombadillo
cloneRepo cwm
cloneRepo dvdrip
cloneRepo firefox-esr-bin
cloneRepo flacon
cloneRepo jdownloader2
cloneRepo jmeter
cloneRepo jmeter-plugins-manager
#cloneRepo lagrange
cloneRepo postman-bin
cloneRepo pygtk
cloneRepo scrcpy
cloneRepo tor-browser
cloneRepo tsmuxer-git
cloneRepo vim-gnupg
cloneRepo vscodium-bin
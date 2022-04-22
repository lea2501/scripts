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

#cloneRepo commander-genius-git
cloneRepo chocolate-doom
cloneRepo crispy-doom
cloneRepo d1x-rebirth
cloneRepo d2x-rebirth
cloneRepo devilutionx
cloneRepo dhewm3
cloneRepo dosbox-staging
cloneRepo dxvk-bin
cloneRepo eduke32
cloneRepo gzdoom
#cloneRepo hexen2
#cloneRepo infra-arcana
cloneRepo libstdc++296
cloneRepo mangohud
cloneRepo nblood-git
cloneRepo ncurses5-compat-libs
cloneRepo nestopia
#cloneRepo pcsx2-git
cloneRepo prboom-plus
cloneRepo qpakman
cloneRepo quakespasm
cloneRepo raze
cloneRepo sameboy
#cloneRepo serious-engine-git
cloneRepo termcap
cloneRepo tyrquake-git
cloneRepo vtable-dumper
cloneRepo xash3d-fwgs-git
cloneRepo yamagi-quake2
cloneRepo yamagi-quake2-rogue
cloneRepo yamagi-quake2-xatrix
cloneRepo yuzu-mainline-bin
cloneRepo zmusic
cloneRepo abi-compliance-checker
cloneRepo abi-dumper
cloneRepo alephone
cloneRepo alephone-evil
cloneRepo alephone-infinity
cloneRepo alephone-marathon
cloneRepo alephone-marathon2
cloneRepo alephone-rubiconx
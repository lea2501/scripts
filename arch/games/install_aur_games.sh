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

#cloneRepo commander-genius-git
#cloneRepo libstdc++296
cloneRepo dxvk-bin && makepkg -sic --noconfirm
cloneRepo ncurses5-compat-libs
cloneRepo alephone
cloneRepo alephone-evil
cloneRepo alephone-infinity
cloneRepo alephone-marathon
cloneRepo alephone-marathon2
cloneRepo alephone-rubiconx
cloneRepo chocolate-doom && makepkg -sic --noconfirm --skippgpcheck
cloneRepo crispy-doom
cloneRepo d1x-rebirth
cloneRepo d2x-rebirth
cloneRepo devilutionx
cloneRepo dhewm3
cloneRepo dosbox-staging
cloneRepo eduke32
cloneRepo zmusic
#cloneRepo vtable-dumper
#cloneRepo abi-dumper
#cloneRepo abi-compliance-checker
cloneRepo gzdoom
#cloneRepo hexen2
#cloneRepo infra-arcana
cloneRepo mangohud
cloneRepo nblood-git
cloneRepo nestopia
#cloneRepo pcsx2-git
cloneRepo prboom-plus
cloneRepo qpakman
cloneRepo quakespasm
cloneRepo raze
cloneRepo sameboy
#cloneRepo serious-engine-git
cloneRepo tyrquake-git
#cloneRepo termcap
cloneRepo umoria
cloneRepo xash3d-fwgs-git
cloneRepo yamagi-quake2
cloneRepo yamagi-quake2-rogue
cloneRepo yamagi-quake2-xatrix
cloneRepo yuzu-mainline-bin

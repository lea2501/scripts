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

#cloneRepo commander-genius-git && makepkg -sic --noconfirm
#cloneRepo libstdc++296 && makepkg -sic --noconfirm

cloneRepo dxvk-bin && makepkg -sic --noconfirm
cloneRepo alephone && makepkg -sic --noconfirm
cloneRepo alephone-evil && makepkg -sic --noconfirm
cloneRepo alephone-infinity && makepkg -sic --noconfirm
cloneRepo alephone-marathon && makepkg -sic --noconfirm
cloneRepo alephone-marathon2 && makepkg -sic --noconfirm
cloneRepo alephone-rubiconx && makepkg -sic --noconfirm
cloneRepo chocolate-doom && makepkg -sic --noconfirm --skippgpcheck
cloneRepo crispy-doom && makepkg -sic --noconfirm --skippgpcheck
cloneRepo d1x-rebirth # && makepkg -sic --noconfirm
cloneRepo d2x-rebirth # && makepkg -sic --noconfirm
cloneRepo smpq && makepkg -sic --noconfirm
cloneRepo devilutionx # && makepkg -sic --noconfirm
cloneRepo dhewm3 && makepkg -sic --noconfirm
cloneRepo munt && makepkg -sic --noconfirm
cloneRepo dosbox-staging && makepkg -sic --noconfirm
cloneRepo eduke32 && makepkg -sic --noconfirm
cloneRepo zmusic && makepkg -sic --noconfirm
#cloneRepo vtable-dumper && makepkg -sic --noconfirm
#cloneRepo abi-dumper && makepkg -sic --noconfirm
#cloneRepo abi-compliance-checker && makepkg -sic --noconfirm
cloneRepo gzdoom && makepkg -sic --noconfirm
#cloneRepo hexen2 && makepkg -sic --noconfirm
#cloneRepo infra-arcana && makepkg -sic --noconfirm
cloneRepo mangohud && makepkg -sic --noconfirm
cloneRepo nblood-git && makepkg -sic --noconfirm
cloneRepo nestopia && makepkg -sic --noconfirm
cloneRepo pcsx2-git && makepkg -sic --noconfirm
cloneRepo prboom-plus && makepkg -sic --noconfirm
cloneRepo qpakman && makepkg -sic --noconfirm
cloneRepo quakespasm && makepkg -sic --noconfirm
cloneRepo raze && makepkg -sic --noconfirm
cloneRepo sameboy && makepkg -sic --noconfirm
#cloneRepo serious-engine-git && makepkg -sic --noconfirm
cloneRepo tyrquake-git && makepkg -sic --noconfirm
cloneRepo termcap && makepkg -sic --noconfirm
cloneRepo ncurses5-compat-libs && makepkg -sic --noconfirm
cloneRepo umoria && makepkg -sic --noconfirm
#cloneRepo xash3d-fwgs-git && makepkg -sic --noconfirm
cloneRepo yamagi-quake2 && makepkg -sic --noconfirm
cloneRepo yamagi-quake2-rogue && makepkg -sic --noconfirm
cloneRepo yamagi-quake2-xatrix && makepkg -sic --noconfirm
#cloneRepo yuzu-mainline-bin && makepkg -sic --noconfirm

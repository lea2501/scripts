#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

username=$USER

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

cloneSrc() {
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

download() {
  mkdir -p ~/bin
  cd ~/bin || return
  curl -o "$1" -L "$2"
}

options=(Y y N n)

# Section: games
read -rp "install games?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  cd || return

  # roguelikes
  paru -S nethack rogue stone-soup cataclysm-dda bsd-games angband infra-arcana umoria

  # doom
  paru -S chocolate-doom crispy-doom prboom-plus gzdoom

  # doom3
  paru -S dhewm3

  # quake
  paru -S quakespasm qpakman

  # quake2
  paru -S yamagi-quake2 yamagi-quake2-rogue yamagi-quake2-xatrix

  # hexen2
  paru -S hexen2

  # half life
  paru -S xash3d-fwgs-git

  # build games
  paru -S eduke32 nblood raze

  # rtcw
  #paru -S iortcw-git iortcw-data

  # marathon
  paru -S alephone alephone-marathon alephone-marathon2 alephone-rubiconx alephone-infinity

  # descent
  paru -S d1x-rebirth d2x-rebirth

  # diablo
  paru -S devilutionx

  # uqm
  paru -S uqm uqm-sound uqm-remix

  # minetest
  paru -S minetest minetest-server

  # applications
  paru -S flacon tsmuxer-git jdownloader2 mangohud

  # torcs
  paru -S torcs torcs-data speed-dreams-svn

  # emulators
  paru -S dosbox mgba snes9x mupen64plus dolphin-emu higan mednafen hatari ppsspp scummvm scummvm-tools fs-uae fs-uae-launcher sameboy nestopia pcsx2-git yuzu-git

  # wine
  paru -S wine wine-gecko wine-mono winetricks zenity vkd3d

  # retroarch
  paru -S retroarch libretro libretro-dosbox-pure-git libretro-beetle-saturn-git libretro-opera-git

  # games
  paru -S lbreakout2

  echo "Installing games... DONE"
fi

# Section: external games
read -rp "install external games?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  # frogcomposband
  echo "Installing frogcomposband..."
  #sudo pacman -Sy --noconfirm autoconf
  #sudo pacman -Sy --noconfirm gcc
  #sudo pacman -Sy --noconfirm libx11
  #gpg --keyserver keys.gnupg.net --recv-keys 702353E0F7E48EDB
  #cloneAurAndCompile ncurses5-compat-libs
  #cloneAurAndCompile libstdc++296 # Edit PKGBUILD manually (https://aur.archlinux.org/packages/libstdc%2B%2B296/)
  #cloneSrc frogcomposband https://github.com/sulkasormi/frogcomposband.git
  #cd frogcomposband && sh autogen.sh && ./configure --prefix "$HOME"/.frogcomposband && make clean && make && make install # run this after installing libstdc++296 AUR package
  echo "Installing frogcomposband... DONE"


  # quakeinjector
  echo "Installing quakeinjector... DONE"
  cd ~/games || return
  mkdir -p quakeinjector
  cd ~/games/quakeinjector || return
  mkdir -p bin
  mkdir -p downloads
  cd ~/games/quakeinjector/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/hrehfeld/QuakeInjector/releases/latest | jq -r ".assets[] | select(.name | test(\"quakeinjector\")) | .browser_download_url")"
  unzip quakeinjector*.zip
  echo "Installing quakeinjector... DONE"


  # prboom-plus
  echo "Installing prboom-plus..."
  cloneSrc prboom-plus https://github.com/coelckers/prboom-plus.git
  cd ~/src/prboom-plus/prboom2 && cmake . && make
  echo "Installing prboom-plus... DONE"
fi

# Section: Add user to games group
read -rp "Add user to games group?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  username=$(echo "$USER")
  gpasswd -a "${username}" games
fi

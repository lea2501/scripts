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
  echo \
    'nethack
rogue
stone-soup
cataclysm-dda
bsd-games
angband
infra-arcana
umoria' >packages_games.txt

  # roguelikes
  echo \
    'nethack
rogue
stone-soup
cataclysm-dda
bsd-games
angband
infra-arcana
umoria' >packages_games.txt

  # doom
  echo \
    'chocolate-doom
crispy-doom
prboom-plus
gzdoom' >packages_games.txt

  # doom3
  echo \
    'dhewm3' >packages_games.txt

  # quake
  echo \
    'quakespasm
qpakman' >packages_games.txt

  # quake2
  echo \
    'yamagi-quake2
yamagi-quake2-rogue
yamagi-quake2-xatrix' >packages_games.txt

  # hexen2
  echo \
    'hexen2' >packages_games.txt

  # half life
  echo \
    'xash3d-fwgs-git' >packages_games.txt

  # build games
  echo \
    'eduke32
nblood
raze' >packages_games.txt

  # rtcw
  echo \
    'iortcw-git
iortcw-data' >packages_games.txt

  # marathon
  echo \
    'alephone
alephone-marathon
alephone-marathon2
alephone-rubiconx
alephone-infinity' >packages_games.txt

  # descent
  echo \
    'd1x-rebirth
  d2x-rebirth' >packages_games.txt

  # diablo
  echo \
    'devilutionx' >packages_games.txt

  # uqm
  echo \
    'uqm
uqm-sound
uqm-remix' >packages_games.txt

  # minetest
  echo \
    'minetest
minetest-server' >packages_games.txt

  # applications
  echo \
    'flacon
tsmuxer-git
jdownloader2
mangohud' >packages_games.txt

  # torcs
  echo \
    'torcs
torcs-data
speed-dreams-svn' >packages_games.txt

  # emulators
  echo \
    'dosbox
mgba
snes9x
mupen64plus
dolphin-emu
higan
mednafen
hatari
ppsspp
scummvm scummvm-tools
fs-uae fs-uae-launcher
sameboy
nestopia
pcsx2-git
yuzu-git' >packages_games.txt

  # wine
  echo \
    'wine wine-gecko wine-mono winetricks zenity vkd3d lutris' >packages_games.txt

  # retroarch
  echo \
    'retroarch libretro
libretro-dosbox-pure-git
libretro-beetle-saturn-git
libretro-opera-git' >packages_games.txt

  # games
  echo \
    'lbreakout2' >packages_games.txt

  echo "Cleaning temporary data... "
  for dir in ~/aur/*; do
    cd "$dir" || exit
    CURRENT_DIR=$(basename "$PWD")
    rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
  done
  echo "Cleaning temporary data... DONE"

  paru -S $(cat packages_games.txt)

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

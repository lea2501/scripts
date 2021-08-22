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

  echo "Installing games..."

  # roguelikes
  echo \
    'angband
moria
nethack-console
cataclysm-dda-curses
games-rogue' >packages_games.txt

  # doom
  echo \
    'chocolate-doom
crispy-doom
prboom-plus
glbsp zdbsp' >>packages_games.txt

  # doom3
  echo \
    'dhewm3 dhewm3-doom3 dhewm3-d3xp
  rbdoom3bfg' >>packages_games.txt

  # quake
  echo \
    'quakespasm' >>packages_games.txt

  # quake2
  echo \
    'yamagi-quake2' >>packages_games.txt

  # hexen2
  echo \
    'uhexen2' >>packages_games.txt

  # rtcw
  echo \
    'rtcw' >>packages_games.txt

  # descent
  #echo \
  #  'd1x-rebirth
  #d2x-rebirth' >>packages_games.txt

  # uqm
  echo \
    'uqm' >>packages_games.txt

  # minetest
  echo \
    'minetest minetest-server' >>packages_games.txt

  # tor
  echo \
    'tor obfs4proxy' >>packages_games.txt

  # torcs
  echo \
    'torcs torcs-data' >>packages_games.txt

  # emulators
  echo \
    'dosbox
mgba-sdl
mednafen
higan
hatari
scummvm scummvm-tools
fs-uae fs-uae-launcher
nestopia
mame mame-tools' >>packages_games.txt

  # wine
  echo \
    'wine wine64' >>packages_games.txt
    #'wine wine64 dxvk' >>packages_games.txt

  # retroarch
  echo \
    'retroarch' >>packages_games.txt

  # other games
  echo \
    'lbreakout2
micropolis
lincity' >>packages_games.txt

  sudo apt-get -y install $(cat packages_games.txt)

  echo "Installing games... DONE"
fi

# Section: angband
read -rp "install angband?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing angband..."
  sudo apt-get install -y build-essential autoconf gcc libc6-dev libncursesw5-dev libx11-dev
  cloneSrc angband https://github.com/angband/angband.git
  ./autogen.sh
  ./configure --with-no-install -disable-x11
  make
  echo "Installing angband... DONE"
fi

# Section: frogcomposband
read -rp "install frogcomposband?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing frogcomposband..."
  sudo apt-get install -y autoconf gcc libc6-dev libncursesw5-dev libx11-dev
  cloneSrc frogcomposband https://github.com/sulkasormi/frogcomposband.git
  sh autogen.sh
  ./configure --prefix "$HOME"/.frogcomposband --with-no-install
  make clean
  make
  echo "Installing frogcomposband... DONE"
fi

# Section: quakeinjector
read -rp "install quakeinjector?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing quakeinjector..."
  cd ~/games || return
  mkdir -p quakeinjector
  cd ~/games/quakeinjector || return
  mkdir -p bin
  mkdir -p downloads
  cd ~/games/quakeinjector/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/hrehfeld/QuakeInjector/releases/latest | jq -r ".assets[] | select(.name | test(\"quakeinjector\")) | .browser_download_url")"
  unzip quakeinjector*.zip
  echo "Installing quakeinjector... DONE"
fi

# Section: prboom-plus
read -rp "install prboom-plus?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing prboom-plus..."
  cloneSrc prboom-plus https://github.com/coelckers/prboom-plus.git
  cd ~/src/prboom-plus/prboom2 && cmake . && make
  echo "Installing prboom-plus... DONE"
fi

# Section: gzdoom
read -rp "install gzdoom?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing gzdoom..."
  sudo apt-get install -y g++ make cmake libsdl2-dev git zlib1g-dev libbz2-dev libjpeg-dev libfluidsynth-dev libgme-dev libopenal-dev libmpg123-dev libsndfile1-dev libgtk-3-dev timidity nasm libgl1-mesa-dev tar libsdl1.2-dev libglew-dev

  mkdir -p ~/src/gzdoom_build
  cd ~/src/gzdoom_build || return
  if [ ! -d gzdoom ]; then
    git clone https://github.com/coelckers/gzdoom.git
    cd gzdoom || return
  else
    cd gzdoom || return
    git pull
  fi

  cd ~/gzdoom_build &&
  mkdir -pv gzdoom/build

  cd gzdoom || return
  git config --local --add remote.origin.fetch +refs/tags/*:refs/tags/*
  git pull

  cd ~/gzdoom_build &&
  wget -nc http://zdoom.org/files/fmod/fmodapi44464linux.tar.gz &&
  tar -xvzf fmodapi44464linux.tar.gz -C gzdoom

  cd ~/gzdoom_build/gzdoom/build &&
  cmake .. -DNO_FMOD=ON

  #cd ~/gzdoom_build/gzdoom/build &&
  #cmake .. -DNO_FMOD=OFF

  cd ~/gzdoom_build/gzdoom &&
  git checkout master
  echo "Installing gzdoom... DONE"
fi

# Section: build engine games
read -rp "install build engine games?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing build engine games..."
  sudo apt-get -y install build-essential nasm libgl1-mesa-dev libglu1-mesa-dev libsdl1.2-dev libsdl-mixer1.2-dev libsdl2-dev libsdl2-mixer-dev flac libflac-dev libvorbis-dev libvpx-dev libgtk2.0-dev freepats

  cloneSrc eduke32 https://voidpoint.io/terminx/eduke32.git
  cd eduke32 || return
  make

  cloneSrc NBlood https://github.com/nukeykt/NBlood.git
  cd NBlood || return
  make
  echo "Installing build engine games... DONE"
fi

# Section: alephone
read -rp "install alephone?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing alephone..."
  mkdir -p ~/bin
  cd ~/bin || return
  curl -OL "$(curl -s https://api.github.com/repos/Aleph-One-Marathon/alephone/releases/latest | jq -r ".assets[] | select(.name | test(\"tar.bz2\")) | .browser_download_url" | head -n 1)"
  tar -zxvf AlephOne-*.tar.gz

  curl -s https://api.github.com/repos/Aleph-One-Marathon/alephone/releases/latest | jq -r ".assets[] | select(.name | test(\"Data.zip\")) | .browser_download_url" | xargs -n1 curl -OL
  curl -OL "http://files3.bungie.org/trilogy/MarathonRED.zip"
  curl -OL "http://files5.bungie.org/marathon/marathonRubiconX.zip"
  curl -o "Marathon_Phoenix.zip" -L "http://simplici7y.com/items/marathon-phoenix-2/download"
  curl -OL "http://eternal.bungie.org/files/_releases/EternalXv120.zip"
  echo "Installing alephone... DONE"
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

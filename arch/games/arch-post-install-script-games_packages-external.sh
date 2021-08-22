#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

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
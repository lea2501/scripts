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


# gzdoom
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


# build games
echo "Installing build games..."
sudo apt-get -y install build-essential nasm libgl1-mesa-dev libglu1-mesa-dev libsdl1.2-dev libsdl-mixer1.2-dev libsdl2-dev libsdl2-mixer-dev flac libflac-dev libvorbis-dev libvpx-dev libgtk2.0-dev freepats

cloneSrc eduke32 https://voidpoint.io/terminx/eduke32.git
cd eduke32 || return
make

cloneSrc NBlood https://github.com/nukeykt/NBlood.git
cd NBlood || return
make
echo "Installing build games... DONE"


# marathon
echo "Installing marathon..."
#cloneAurAndCompile alephone
#cloneAurAndCompile alephone-marathon
#cloneAurAndCompile alephone-marathon2
#cloneAurAndCompile alephone-rubiconx
#cloneAurAndCompile alephone-infinity
echo "Installing marathon... DONE"

echo "Installing games packages... DONE"

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get install -y g++ make cmake libsdl2-dev git zlib1g-dev libbz2-dev libjpeg-dev libfluidsynth-dev libgme-dev libopenal-dev libmpg123-dev libsndfile1-dev libgtk-3-dev timidity nasm libgl1-mesa-dev tar libsdl1.2-dev libglew-dev

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
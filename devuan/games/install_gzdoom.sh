#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get install -y --no-install-recommends g++ make cmake libsdl2-dev git zlib1g-dev libbz2-dev libjpeg-dev libgme-dev libopenal-dev libmpg123-dev libsndfile1-dev libgtk-3-dev timidity nasm libgl1-mesa-dev tar libsdl1.2-dev libglew-dev libvpx-dev #libfluidsynth-dev

application=ZMusic
repository=https://github.com/coelckers/ZMusic.git
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

mkdir -pv build
cd build || return
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build .
$su make install

application=gzdoom
repository=https://github.com/coelckers/gzdoom.git
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

mkdir -pv build
cd build || return
wget -nc http://zdoom.org/files/fmod/fmodapi44464linux.tar.gz &&
tar -xvzf fmodapi44464linux.tar.gz -C .

cmake .. -DNO_FMOD=ON
#cmake .. -DNO_FMOD=OFF
$su make install

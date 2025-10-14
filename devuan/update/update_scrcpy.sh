#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt update
$su apt-get -y --fix-missing install \
        ffmpeg libsdl2-2.0-0 adb wget gcc git pkg-config meson ninja-build \
        libsdl2-dev libavcodec-dev libavdevice-dev libavformat-dev \
        libavutil-dev libswresample-dev libusb-1.0-0 libusb-1.0-0-dev

application=scrcpy
repository=https://github.com/Genymobile/scrcpy.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
  export compile=true
else
  cd $application || return
  #git pull
  pwd
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    pwd
    echo "Need to pull"
    git pull
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application || return
  ./install_release.sh
fi

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y build-essential cmake libboost-all-dev libsdl1.2-dev libsdl-image1.2-dev \
  libsdl-net1.2-dev libsdl-ttf2.0-dev libspeexdsp-dev libzzip-dev \
  libavcodec-dev libavformat-dev libavutil-dev libswscale-dev

application=alephone
if [ ! -f ~/src/$application ]; then
  cd ~/src || return
  curl -o AlephOne-stable.tar.bz2 -L https://alephone.lhowon.org/download/source.php
  tar xjvf AlephOne-stable.tar.bz2
  # main directory
  mv AlephOne-*/ $application
  cd $application
  ./configure
  make
fi

# games data
if [ ! -d ~/games/alephone ]; then
  mkdir -p ~/games/alephone
  cd ~/games/alephone
  curl -s https://api.github.com/repos/Aleph-One-Marathon/alephone/releases/latest | jq -r ".assets[] | select(.name | test(\"Data.zip\")) | .browser_download_url" | xargs -n1 curl -OL

  if [ ! -d marathon ]; then
    unzip Marathon-*-Data.zip -d marathon
    mv marathon/Marathon/* marathon/
    rm -rf marathon/Marathon
  fi

  if [ ! -d marathon2 ]; then
    unzip Marathon2-*-Data.zip -d marathon2
    mv marathon2/Marathon\ 2/* marathon2/
    rm -rf marathon2/Marathon\ 2
  fi

  if [ ! -d infinity ]; then
    unzip MarathonInfinity-*-Data.zip -d infinity
    mv infinity/Marathon\ Infinity/* infinity/
    rm -rf infinity/Marathon\ Infinity
  fi

  if [ ! -d marathon_red ]; then
    curl -OL "http://files3.bungie.org/trilogy/MarathonRED.zip"
    unzip MarathonRED.zip -d marathon_red
    mv marathon_red/Marathon\ RED/* marathon_red/
    rm -rf marathon_red/Marathon\ RED
  fi

  if [ ! -d rubicon_x ]; then
    curl -OL "http://files5.bungie.org/marathon/marathonRubiconX.zip"
    unzip marathonRubiconX.zip -d rubicon_x/
    mv rubicon_x/Rubicon\ X\ ƒ/* rubicon_x/
    rm -rf rubicon_x/__MACOSX/ rubicon_x/Rubicon\ X\ ƒ/
  fi

  if [ ! -d phoenix ]; then
    curl -o "Marathon_Phoenix.zip" -L "http://simplici7y.com/items/marathon-phoenix-2/download"
    unzip Marathon_Phoenix.zip -d phoenix/
    mv phoenix/Marathon\ Phoenix/* phoenix/
    rm -rf phoenix/Marathon\ Phoenix/
  fi

  if [ ! -d eternal ]; then
    curl -OL "http://eternal.bungie.org/files/_releases/EternalXv121.zip"
    unzip EternalXv121.zip -d eternal/
    mv eternal/Eternal\ 1.2.1/* eternal/
    rm -rf eternal/__MACOSX/ eternal/Eternal\ 1.2.1/
  fi

  if [ ! -d evil ]; then
    curl -OL "http://files3.bungie.org/trilogy/MarathonEvil.zip"
    unzip MarathonEvil.zip -d evil/
    mv evil/Marathon\ EVIL/* evil/
    rm -rf evil/Marathon\ EVIL/
  fi

  if [ ! -d pathways_into_darkness ]; then
    curl -o "AOPID_v1.2.zip" -L "https://simplici7y.com/items/aleph-one-pathways-into-darkness/download"
    unzip AOPID_v1.2.zip -d pathways_into_darkness/
    mv pathways_into_darkness/AOPID_v1.2/* pathways_into_darkness/
    rm -rf pathways_into_darkness/AOPID_v1.2/
  fi
fi
#!/bin/bash

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su pacman -Sy --noconfirm --needed autoconf gcc

application=wadtools
repository="https://github.com/makise-homura/wadtools.git"
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
  mkdir -p build
  cd build || return
  gcc ../wadbuild.c -o wadbuild
  gcc ../wadxtract.c -o wadxtract
  gcc ../wadfindthing.c -o wadfindthing
  #gcc ../wadpack.c -o wadpack	# compiling error
  #$su cp wadbuild wadxtract wadpack wadfindthing /usr/local/bin
fi

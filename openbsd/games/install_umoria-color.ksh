#!/bin/ksh

# https://github.com/andrewtweber/umoria-color/issues/7

doas pkg_add autoconf-2.71 gcc-11.2.0p9 gmake

application=umoria-color
repository=https://github.com/andrewtweber/umoria-color.git
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
  git stash && git stash clear
  mkdir -p build && cd build
  sed -ie 's/CMAKE_CXX_COMPILER g++/CMAKE_CXX_COMPILER eg++/g' ../CMakeLists.txt
  sed -ie 's/ __MORPHOS__/ __MORPHOS__  || __OpenBSD__/g' ../src/headers.h
  cmake ..
  gmake
fi

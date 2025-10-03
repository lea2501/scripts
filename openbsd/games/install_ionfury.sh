#!/bin/ksh

doas pkg_add automake-1.16.5 autoconf-2.71 gcc-11.2.0p9 gmake nasm sdl2 sdl2-net sdl2-mixer flac libvpx unzip gtk+2 gdk-pixbuf2 libxmp lz4 xz libvorbis

application=eduke32-fury
repository=https://voidpoint.io/terminx/eduke32.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository $application
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
  gmake CXX=eg++ USE_OPENGL=1 POLYMER=0 HAVE_GTK2=1 STARTUP_WINDOW=1 USE_LIBVPX=1 CLANG=1 RELEASE=1 FURY=1
fi

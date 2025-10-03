#!/bin/ksh

doas pkg_add cmake gmake sdl2 sdl2-net sdl2-mixer libsamplerate png

application=chocolate-doom
repository=https://github.com/chocolate-doom/chocolate-doom.git
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
  echo ""
  echo "NOTE: If getting a 'Provide an AUTOMAKE_VERSION environment variable, please' error do this:"
  echo "$ export AUTOMAKE_VERSION=1.16 # <- (version without minor number 1.16.5 > 1.16)"
  echo "$ export AUTOCONF_VERSION=2.69 # <- (version without minor number 2.69p3 > 2.69)"
  echo ""
  export AUTOMAKE_VERSION=1.16
  export AUTOCONF_VERSION=2.71
  #sed -i 's/HAVE_PYTHON, python/HAVE_PYTHON, python${MODPY_MAJOR_VERSION}/' configure.ac
  sed -i 's/HAVE_PYTHON, python/HAVE_PYTHON, python3.11/' configure.ac
  sh autogen.sh
  ./configure
  cmake .
  gmake
fi

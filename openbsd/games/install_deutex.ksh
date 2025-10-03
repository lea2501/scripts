#!/bin/ksh

doas pkg_add cmake gmake

application=deutex
repository=https://github.com/Doom-Utils/deutex.git
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
  echo "$ export AUTOCONF_VERSION=2.71 # <- (version without minor number 2.71p3 > 2.71)"
  echo ""
  export AUTOMAKE_VERSION=1.16
  export AUTOCONF_VERSION=2.71
  ./bootstrap
  ./configure
  gmake
fi

#!/bin/ksh

doas pkg_add autoconf gcc gmake

application=frogcomposband
repository=https://github.com/sulkasormi/frogcomposband.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
  export compile=true
else
  cd $application || return
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    echo "Need to pull"
    git pull
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application || return
  sh autogen.sh
  chmod +x configure
  ./configure --prefix "$HOME"/.frogcomposband --with-no-install --disable-x11
  gmake clean
  gmake
fi

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get install -y autoconf gcc libc6-dev libncursesw5-dev libx11-dev

application=frogcomposband
repository=https://github.com/sulkasormi/frogcomposband.git
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

cd ~/src/frogcomposband || return
sh autogen.sh
chmod +x configure
./configure --prefix "$HOME"/.frogcomposband --with-no-install
make clean
make

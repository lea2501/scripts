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
./clone_src.sh frogcomposband https://github.com/sulkasormi/frogcomposband.git
cd ~/src/frogcomposband || return
sh autogen.sh
./configure --prefix "$HOME"/.frogcomposband --with-no-install
make clean
make
echo "Installing frogcomposband... DONE"
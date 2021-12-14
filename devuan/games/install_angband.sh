#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get install -y build-essential autoconf gcc libc6-dev libncursesw5-dev libx11-dev
./clone_src.sh angband https://github.com/angband/angband.git
cd ~/src/angband || return
./autogen.sh
./configure --with-no-install -disable-x11
make clean
make
echo "Installing angband... DONE"
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y build-essential autoconf gcc libc6-dev libncursesw5-dev libx11-dev

application=angband
repository=https://github.com/angband/angband.git
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

cd ~/src/$application || return
./autogen.sh
./configure --with-no-install -disable-x11
make clean
make

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

application=umoria
repository=https://github.com/dungeons-of-moria/umoria.git
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
mkdir build && cd build
cmake ..
make
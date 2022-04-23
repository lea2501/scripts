#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

mkdir -p ~/src
cd ~/src || return
if [ ! -d badwolf ]; then
  git clone https://hacktivis.me/git/badwolf.git
  cd badwolf || return
else
  cd badwolf || return
  git pull
fi

./configure
make
$su make install
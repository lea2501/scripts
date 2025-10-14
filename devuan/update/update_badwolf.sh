#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y mandoc shellcheck flawfinder libxml2-dev libwebkit2gtk-4.1-dev gettext

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

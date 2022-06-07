#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

# bsp
mkdir -p ~/src/bsp && cd ~/src/bsp && curl -O http://games.moria.org.uk/doom/bsp/download/bsp-5.2.tar.bz2 && tar -xjvf bsp-5.2.tar.bz2 && cd bsp-5.2
./configure && make

# slige
$su dpkg --add-architecture i386
$su apt-get install -y libc6-dev-i386

mkdir -p ~/src/xwadtools && cd ~/src/xwadtools/ && curl -O ftp://ftp.fu-berlin.de/pc/games/idgames/source/xwadtools-20010615.tar.gz && tar -xzvf xwadtools-20010615.tar.gz
cp -r ~/src/xwadtools/xwadtools/slige ~/src/ && cd ~/src/slige
cc -m32 slige.c -o slige

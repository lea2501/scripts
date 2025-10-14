#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt install libcurl4 rsync libpng-dev libfreetype6 libvorbisfile3

version=0.8.6

mkdir -p ~/src/
cd ~/src/
curl -OL --retry-connrefused --retry 10 https://dl.xonotic.org/xonotic-${version}.zip
unzip xonotic-${version}.zip
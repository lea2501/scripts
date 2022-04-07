#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

application=prboom-plus
repository=https://github.com/coelckers/prboom-plus.git
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

cd ~/src/prboom-plus/prboom2 || return
cmake .
make
echo "Installing prboom-plus... DONE"
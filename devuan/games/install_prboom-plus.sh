#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

./clone_src.sh prboom-plus https://github.com/coelckers/prboom-plus.git
cd ~/src/prboom-plus/prboom2 || return
cmake .
make
echo "Installing prboom-plus... DONE"
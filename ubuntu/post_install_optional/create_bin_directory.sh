#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cd || return
mkdir -p ~/bin
echo "PATH=\$PATH:~/bin/" >>~/.bashrc
source ~/.bashrc

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Creating user 'bin' directory..."
cd || return
mkdir -p ~/bin
echo "PATH=\$PATH:~/bin/" >>~/.bashrc
source ~/.bashrc
echo "Creating user 'bin' directory... DONE"
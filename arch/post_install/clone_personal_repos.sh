#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Creating ~/src directory..."
mkdir -p ~/src
echo "Creating ~/src directory... DONE"
echo "Cloning Github repos..."
cd ~/src || return
git clone git@github.com:lea2501/dotfiles.git
git clone git@github.com:lea2501/scripts.git
git clone git@github.com:lea2501/guides.git
echo "Cloning Github repos... DONE"
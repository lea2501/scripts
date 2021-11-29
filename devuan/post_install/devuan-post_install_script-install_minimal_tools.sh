#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing packages 'minimal tools'..."
sudo apt-get -y install stterm
sudo apt-get -y install cwm
cd || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.cwmrc"
echo "Installing packages 'minimal tools'... DONE"
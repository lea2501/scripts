#!/bin/bash

# fail if any commands fails
set -e
# debug log
set -x

mkdir -p ~/Downloads
cd ~/Downloads || return
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
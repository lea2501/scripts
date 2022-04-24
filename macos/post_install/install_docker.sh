#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing docker requires to manually install the application."
echo "After downloading please install manually"
mkdir -p ~/Downloads
cd ~/Downloads || return
curl -OL "https://desktop.docker.com/mac/stable/Docker.dmg"
open "Docker.dmg"
read -p "Press enter to continue after Docker installation..."
rm "Docker.dmg

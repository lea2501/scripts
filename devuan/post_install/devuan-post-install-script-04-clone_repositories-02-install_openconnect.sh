#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "installing packages..."
sudo apt-get -y install openconnect
sudo apt-get -y install network-manager-openconnect
echo "installing packages... DONE"
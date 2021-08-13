#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "installing packages..."
sudo apt install -y openconnect
sudo apt install -y network-manager-openconnect
echo "installing packages... DONE"
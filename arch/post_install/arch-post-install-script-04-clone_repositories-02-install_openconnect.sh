#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "installing packages..."
sudo pacman -Sy --noconfirm --needed openconnect
sudo pacman -Sy --noconfirm --needed networkmanager-openconnect
echo "installing packages... DONE"
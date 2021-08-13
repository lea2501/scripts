#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing xorg packages..."
echo ""
sudo apt install -y xorg
echo "Installing xorg packages... DONE"

echo "Creating ~/.xinitrc file..."
cp /etc/X11/xinit/xinitrc ~/.xinitrc
echo "Creating ~/.xinitrc file... DONE"
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Installing xorg packages..."
echo ""
$su apt-get -y install xorg
echo "Installing xorg packages... DONE"

echo "Creating ~/.xinitrc file..."
cp /etc/X11/xinit/xinitrc ~/.xinitrc
echo "Creating ~/.xinitrc file... DONE"
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su pacman -Sy --noconfirm xorg xorg-xinit

cp /etc/X11/xinit/xinitrc ~/.xinitrc
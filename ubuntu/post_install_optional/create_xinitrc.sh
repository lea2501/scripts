#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo ""
$su apt-get -y --fix-missing install xorg

cp /etc/X11/xinit/xinitrc ~/.xinitrc

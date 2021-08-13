#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cd || return
# Set keyboard layout
echo "Set keyboard layout..."
echo "setxkbmap -layout latam -variant deadtilde" >>~/.bash_profile
echo "Set keyboard layout... DONE"
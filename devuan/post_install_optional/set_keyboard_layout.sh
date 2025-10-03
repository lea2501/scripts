#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "setxkbmap -layout latam -variant deadtilde" >>~/.bash_profile

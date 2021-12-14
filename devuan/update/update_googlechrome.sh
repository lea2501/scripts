#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

mkdir -p ~/Downloads
cd ~/Downloads || return
curl -OL "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
$su apt install ./google-chrome-stable_current_amd64.deb
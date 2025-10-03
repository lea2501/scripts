#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get update -qq
$su apt-get install -qq -y curl

cd || return
mkdir -p ~/Applications
cd ~/Applications || return
curl -O -L "$(curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest | jq -r ".assets[] | select(.name | test(\"yt-dlp_linux\")) | .browser_download_url" | head -n 1)"
chmod +x ./yt-dlp_linux
cd - || return

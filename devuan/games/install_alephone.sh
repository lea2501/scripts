#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

mkdir -p ~/bin
cd ~/bin || return
curl -OL "$(curl -s https://api.github.com/repos/Aleph-One-Marathon/alephone/releases/latest | jq -r ".assets[] | select(.name | test(\"tar.bz2\")) | .browser_download_url" | head -n 1)"
tar -zxvf AlephOne-*.tar.gz

curl -s https://api.github.com/repos/Aleph-One-Marathon/alephone/releases/latest | jq -r ".assets[] | select(.name | test(\"Data.zip\")) | .browser_download_url" | xargs -n1 curl -OL
curl -OL "http://files3.bungie.org/trilogy/MarathonRED.zip"
curl -OL "http://files5.bungie.org/marathon/marathonRubiconX.zip"
curl -o "Marathon_Phoenix.zip" -L "http://simplici7y.com/items/marathon-phoenix-2/download"
curl -OL "http://eternal.bungie.org/files/_releases/EternalXv120.zip"
echo "Installing alephone... DONE"
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

mkdir -p ~/bin
cd ~/bin || return
curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
unzip schema_guru_0.6.2.zip
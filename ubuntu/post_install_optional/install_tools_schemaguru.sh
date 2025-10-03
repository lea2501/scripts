#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

mkdir -p ~/bin
cd ~/bin || return
curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
unzip schema_guru_0.6.2.zip

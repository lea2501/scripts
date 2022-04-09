#!/bin/bash

slackbuilds_dir=$HOME/slackbuilds
mkdir -p "$slackbuilds_dir"

cd "$slackbuilds_dir" || exit

# get url from https://sbopkg.org/downloads.php
rm -rf sbopkg-*_wsr.tgz
curl -OL "$(curl -s https://api.github.com/repos/sbopkg/sbopkg/releases/latest | jq -r ".assets[] | select(.name | test(\"_wsr.tgz\")) | .browser_download_url" | head -n 1)"
upgradepkg --install-new sbopkg-*-noarch-1_wsr.tgz

# sync
sbopkg -r

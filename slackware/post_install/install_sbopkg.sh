#!/bin/bash

mkdir -p ~/slackbuilds

cd ~/slackbuilds || exit
# get url from https://sbopkg.org/downloads.php
rm -rf sbopkg-*_wsr.tgz
curl -OL "$(curl -s https://api.github.com/repos/sbopkg/sbopkg/releases/latest | jq -r ".assets[] | select(.name | test(\"_wsr.tgz\")) | .browser_download_url" | head -n 1)"
installpkg sbopkg-*-noarch-1_wsr.tgz

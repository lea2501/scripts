#!/bin/bash

cd || return
mkdir -p ~/bin
cd ~/bin || return
curl -O -L "$(curl -s https://api.github.com/repos/yuzu-emu/yuzu-mainline/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
chmod +x *.AppImage
cd - || return
echo "installing yuzu... DONE"
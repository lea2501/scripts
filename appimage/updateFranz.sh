#!/bin/bash

appimage=meetfranz/franz
cd || return
mkdir -p ~/Applications
cd ~/Applications || return
#curl -O -L "$(curl -s https://api.github.com/repos/"$appimage"/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/"$appimage"/releases/latest | grep browser_download_url | grep "AppImage" | head -n 1 | cut -d '"' -f 4)
curl -OL "$DOWNLOAD_URL"
chmod +x ./*.AppImage
cd - || return
echo "installing $appimage... DONE"
#!/bin/bash

appimage=suciptoid/postman-appimage
cd || return
mkdir -p ~/bin
cd ~/bin || return
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/"$appimage"/releases/latest | grep browser_download_url | grep "AppImage" | sort --version-sort -r | head -n 1 | cut -d '"' -f 4)
curl -OL "$DOWNLOAD_URL"
chmod +x *.AppImage
cd - || return
echo "installing $appimage... DONE"
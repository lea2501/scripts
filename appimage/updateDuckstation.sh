#!/bin/bash

appimage=stenzek/duckstation
asset=DuckStation-x64.AppImage

cd || return
mkdir -p ~/Applications
cd ~/Applications || return
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/"$appimage"/releases/latest | grep browser_download_url | grep "$asset" | head -n 1 | cut -d '"' -f 4)
curl -OL "$DOWNLOAD_URL"
chmod +x ./"$asset"
cd - || return

#!/bin/bash

cd || return
mkdir -p ~/Applications
cd ~/Applications || return
DOWNLOAD_URL=https://rpcs3.net/latest-appimage
curl -JOL "$DOWNLOAD_URL"
chmod +x *.AppImage
cd - || return


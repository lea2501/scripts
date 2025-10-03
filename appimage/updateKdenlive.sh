#!/bin/bash

cd || return
mkdir -p ~/Applications
cd ~/Applications || return
URL=$(curl -s "https://kdenlive.org/download/" | grep -o 'https://download.kde.org[^"]*kdenlive[^"]*x86_64[^"]*\.AppImage' | head -1)
curl -L "$URL" -o kdenlive-latest.AppImage
chmod +x kdenlive-latest.AppImage
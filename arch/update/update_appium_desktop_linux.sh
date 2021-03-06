#!/bin/bash

cd || return
mkdir -p ~/Applications
cd ~/Applications || return
curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-inspector/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
chmod +x ./*.AppImage
cd - || return

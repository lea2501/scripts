#!/bin/bash

# fail if any commands fails
set -e
# debug log
set -x

echo "installing appium desktop..."
cd || return
mkdir -p ~/bin
cd ~/Downloads || return
curl -OL $(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\".dmg\")) | .browser_download_url") --output appium-desktop-latest.out
open ~/Downloads
read -p "Press enter key after installing appium-desktop"
echo "installing appium desktop... DONE"

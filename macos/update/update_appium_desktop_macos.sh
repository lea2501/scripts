#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cd || return
mkdir -p ~/bin
cd ~/Downloads || return
curl -OL $(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\".dmg\")) | .browser_download_url") --output appium-server-latest.out
curl -OL $(curl -s https://api.github.com/repos/appium/appium-inspector/releases/latest | jq -r ".assets[] | select(.name | test(\"dmg\")) | .browser_download_url") --output appium-inspector-latest.out
open ~/Downloads
read -p "Press enter key after installing appium-server and appium-inspector"
echo "installing appium desktop... DONE"

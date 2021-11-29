#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing packages 'appium'..."
# appium
$su pacman -Sy --noconfirm --needed npm cmake
$su pacman -Sy --noconfirm --needed opencv
$su npm install -g appium --unsafe-perm=true --allow-root
$su npm install -g appium-doctor
#$su npm install -g opencv4nodejs --unsafe-perm=true --allow-root
npm install wd

# appium-desktop
cd || return
mkdir -p ~/bin
cd ~/bin || return
curl -O -L $(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")
curl -O -L $(curl -s https://api.github.com/repos/appium/appium-inspector/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")
chmod +x *.AppImage
echo "Installing packages 'appium'... DONE"
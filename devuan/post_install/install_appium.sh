#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get -y --fix-missing install npm cmake
$su apt-get -y --fix-missing install node-opencv
$su npm install -g appium --unsafe-perm=true --allow-root
$su npm install -g appium-doctor
#$su npm install -g opencv4nodejs --unsafe-perm=true --allow-root
npm install wd

# appium-desktop
cd || return
mkdir -p ~/Applications
cd ~/Applications || return
curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-inspector/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
chmod +x ./*.AppImage
cd - || return

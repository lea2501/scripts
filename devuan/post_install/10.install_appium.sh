#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

cd || return
$su apt-get -y --fix-missing install jq
$su apt-get -y --fix-missing install npm cmake
$su apt-get -y --fix-missing install node-opencv
#$su npm install -g npm@latest
$su npm cache clean --force
$su npm rm -rf node_modules && $su rm -rf package-lock.json
$su npm install -g appium --unsafe-perm=true --allow-root
$su npm install -g appium-doctor
#$su npm install -g opencv4nodejs --unsafe-perm=true --allow-root
$su rm -rf package.json package-lock.json node_modules
npm install wd

appium driver list
appium driver install uiautomator2
appium driver install xcuitest

# appium-desktop
cd || return
mkdir -p ~/Applications
cd ~/Applications || return
curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-inspector/releases/latest | jq -r ".assets[] | select(.name | test(\"linux-x86_64.AppImage\")) | .browser_download_url")"
chmod +x ./*.AppImage
cd - || return

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# appium
echo "installing appium..."
sudo pacman -Sy --noconfirm --needed npm cmake
sudo pacman -Sy --noconfirm --needed opencv
sudo npm install -g appium --unsafe-perm=true --allow-root
sudo npm install -g appium-doctor
#sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
npm install wd

# appium-desktop
cd || return
mkdir -p ~/bin
cd ~/bin || return
curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
chmod +x *.AppImage
echo "installing appium... DONE"

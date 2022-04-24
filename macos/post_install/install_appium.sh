#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

brew install -q libimobiledevice
brew install -q ios-deploy
brew install -q npm cmake
brew install -q carthage
sudo npm install -g appium --unsafe-perm=true --allow-root
sudo npm install -g appium-doctor
#sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
npm install wd

# appium-desktop
cd || return
mkdir -p ~/bin
cd ~/Downloads || return
curl -OL "$(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\".dmg\")) | .browser_download_url")" --output appium-server-latest.out
curl -OL "$(curl -s https://api.github.com/repos/appium/appium-inspector/releases/latest | jq -r ".assets[] | select(.name | test(\"dmg\")) | .browser_download_url")" --output appium-inspector-latest.out
open ~/Downloads
read -p "Press enter key after installing appium-server and appium-inspector"

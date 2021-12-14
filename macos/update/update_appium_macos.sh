#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "installing appium..."
brew install -q libimobiledevice
brew install -q ios-deploy
brew install -q npm cmake
brew install -q carthage
sudo npm install -g appium --unsafe-perm=true --allow-root
sudo npm install -g appium-doctor
#sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
npm install wd
echo "installing appium... DONE"

#!/bin/bash

echo "installing appium..."
cd || return
doas apt-get -y install npm cmake
doas npm install -g appium --unsafe-perm=true --allow-root
doas npm install -g appium-doctor
#sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
npm install wd
cd - || return
echo "installing appium... DONE"
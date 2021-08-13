#!/bin/bash

echo "installing appium..."
cd || return
sudo pacman -Sy --noconfirm --needed npm cmake
sudo npm install -g appium --unsafe-perm=true --allow-root
sudo npm install -g appium-doctor
#sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
npm install wd
cd - || return
echo "installing appium... DONE"
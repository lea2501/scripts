#!/bin/bash

echo "installing appium..."
sudo pacman -Sy --noconfirm --needed npm cmake
sudo npm install -g appium --unsafe-perm=true --allow-root
sudo npm install -g appium-doctor
#sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
npm install wd
echo "installing appium... DONE"
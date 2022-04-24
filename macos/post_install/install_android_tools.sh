#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

brew install -q android-sdk
brew install -q android-platform-tools
brew install -q android-studio
brew install -q android-file-transfer
#brew install -q android-ndk
brew install -q scrcpy
touch ~/.android/repositories.cfg
sdkmanager --update
sdkmanager "platform-tools" "platforms;android-30"
sdkmanager "build-tools;30.0.2"
##echo y | sdkmanager --licenses
yes | sdkmanager --licenses

mkdir -p ~/bin
cd ~/bin || return
curl -OL "https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
unzip platform-tools-latest-darwin.zip
cd || return

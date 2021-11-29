#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing Android packages..."
sudo apt-get -y install adb
sudo apt-get -y install android-sdk
sudo apt-get -y install android-sdk-platform-tools
sudo apt-get -y install android-sdk-build-tools
sudo apt-get -y install fastboot
#sudo apt-get -y install scrcpy #available in testing and sid for now

#{
#  echo "export ANDROID_HOME=/opt/android-sdk/"
#  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
#  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools"
#}>>~/.bashrc
# Relogin or source this file to add android emulator to user path
#source /etc/profile
echo "Installing Android packages... DONE"

{
  echo "export ANDROID_HOME=/opt/android-sdk/"
  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools"
}>>~/.bashrc

# login again or source this file to add android emulator to user path
source /etc/profile
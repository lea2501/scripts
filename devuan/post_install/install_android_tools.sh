#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Installing Android packages..."
$su apt-get -y install adb
$su apt-get -y install android-sdk
$su apt-get -y install android-sdk-platform-tools
$su apt-get -y install android-sdk-build-tools
$su apt-get -y install fastboot
#$su apt-get -y install scrcpy #available in testing and sid for now

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
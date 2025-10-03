#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get -y --fix-missing install adb
$su apt-get -y --fix-missing install android-sdk
$su apt-get -y --fix-missing install android-sdk-platform-tools
$su apt-get -y --fix-missing install android-sdk-build-tools
$su apt-get -y --fix-missing install fastboot
$su apt-get -y --fix-missing install scrcpy
#$su apt-get -y --fix-missing install scrcpy #available in testing and sid for now
#$su apt-get -y --fix-missing install scrcpy/chimaera-backports

{
  echo ""
  echo "# android path"
  echo "export ANDROID_HOME=/opt/android-sdk/"
  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools"
}>>~/.bashrc

# login again or source this file to add android emulator to user path
source /etc/profile

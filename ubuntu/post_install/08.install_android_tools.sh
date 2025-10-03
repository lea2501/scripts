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
$su apt-get -y --fix-missing install android-sdk-platform-tools-common
$su apt-get -y --fix-missing install android-sdk-build-tools
$su apt-get -y --fix-missing install fastboot
$su apt-get -y --fix-missing install scrcpy

$su usermod -aG plugdev $LOGNAME

{
  echo ""
  echo "# android path"
  echo "export ANDROID_HOME=/usr/lib/android-sdk/"
  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
}>>~/.bashrc

# login again or source this file to add android emulator to user path
source ~/.bashrc

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing packages 'android tools'..."
paru -S android-sdk android-sdk-platform-tools android-sdk-build-tools android-platform scrcpy

{
  echo "export ANDROID_HOME=/opt/android-sdk/"
  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools"
}>>~/.bashrc

# login again or source this file to add android emulator to user path
source /etc/profile
echo "Installing packages 'android tools'... DONE"
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cloneRepo() {
  mkdir -p ~/aur
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

cloneAurAndCompile() {
  cloneRepo "$1"
  makepkg -sic --noconfirm
}

# android
cloneAurAndCompile android-sdk
cloneAurAndCompile android-sdk-platform-tools
cloneAurAndCompile android-sdk-build-tools
cloneAurAndCompile android-platform
#cloneAurAndCompile android-ndk
#cloneAurAndCompile android-studio
#cloneAurAndCompile android-emulator
cloneAurAndCompile scrcpy

{
  echo "export ANDROID_HOME=/opt/android-sdk/"
  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools"
}>>~/.bashrc

# login again or source this file to add android emulator to user path
source /etc/profile
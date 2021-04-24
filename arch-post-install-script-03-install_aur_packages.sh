#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

options=(y n)
read -rp "Install extra tools?: (y|n)" installExtraTools
if [[ " "${options[@]}" " != *" $installExtraTools "* ]]; then
  echo "$installExtraTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install basic tools?: (y|n)" installBasicTools
if [[ " "${options[@]}" " != *" $installBasicTools "* ]]; then
  echo "$installBasicTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install browsers?: (y|n)" installBrowsers
if [[ " "${options[@]}" " != *" $installBrowsers "* ]]; then
  echo "$installBrowsers: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install postman?: (y|n)" installPostman
if [[ " "${options[@]}" " != *" $installPostman "* ]]; then
  echo "$installPostman: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install jmeter?: (y|n)" installJmeter
if [[ " "${options[@]}" " != *" $installJmeter "* ]]; then
  echo "$installJmeter: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install allure?: (y|n)" installAllure
if [[ " "${options[@]}" " != *" $installAllure "* ]]; then
  echo "$installAllure: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install schema guru?: (y|n)" installSchemaGuru
if [[ " "${options[@]}" " != *" $installSchemaGuru "* ]]; then
  echo "$installSchemaGuru: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install Android tools?: (y|n)" installAndroidTools
if [[ " "${options[@]}" " != *" $installAndroidTools "* ]]; then
  echo "$installAndroidTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install Appium tools?: (y|n)" installAppiumTools
if [[ " "${options[@]}" " != *" $installAppiumTools "* ]]; then
  echo "$installAppiumTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install forensic tools?: (y|n)" installForensicTools
if [[ " "${options[@]}" " != *" $installForensicTools "* ]]; then
  echo "$installForensicTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi

if [ "$installBrowsers" = "y" ]; then
  echo "Please select browser package to install:"
  echo "    0) Google Chrome"
  echo "    1) Chromium"
  read -rp "0-1: " browserSelect

  browserOptions=(0 1)
  if [[ " "${browserOptions[@]}" " != *" $browserSelect "* ]]; then
    echo "$browserSelect: not recognized. Valid options are:"
    echo "${browserOptions[@]/%/,}"
    exit 1
  fi
fi

cloneAurAndCompile() {
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
  else
    cd "$1" && git pull
  fi
  makepkg -sic --noconfirm
}

cloneAurAndCompileSkipChecks() {
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
  else
    cd "$1" && git pull
  fi
  makepkg -sic --noconfirm --skippgpcheck
}

cloneAurAndCompileSkipInteg() {
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
  else
    cd "$1" && git pull
  fi
  makepkg -sic --noconfirm --skipinteg
}

# AUR packages
echo "installing AUR packages..."

echo "Creating user 'aur' directory..."
mkdir -p ~/aur
echo "Creating user 'aur' directory... DONE"

echo "installing AUR packages..."
if [ "$installExtraTools" = "y" ]; then
  cd ~/aur || return
  if [ ! -d "st" ] ; then
    git clone https://aur.archlinux.org/st.git
  else
    cd st && git pull
  fi
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/st/config.def.h"
  makepkg -sic --noconfirm --skipinteg

  cd ~/aur || return
  if [ ! -d "dwm" ] ; then
    git clone https://aur.archlinux.org/dwm.git
  else
    cd dwm && git pull
  fi
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/dwm/config.h"
  makepkg -sic --noconfirm --skipinteg

  cd ~/aur || return
  if [ ! -d "slstatus-git" ] ; then
    git clone https://aur.archlinux.org/slstatus-git.git
  else
    cd slstatus-git && git pull
  fi
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/slstatus-git/config.h"
  makepkg -sic --noconfirm --skipinteg
fi

if [ "$installBasicTools" = "y" ]; then
  # bash-git-prompt
  cloneAurAndCompile bash-git-prompt
  cloneAurAndCompile icaclient
  mkdir -p "$HOME"/.ICAClient/cache
  cp /opt/Citrix/ICAClient/config/{All_Regions,Trusted_Region,Unknown_Region,canonicalization,regions}.ini "$HOME"/.ICAClient/
fi

if [ "$installBrowsers" = "y" ]; then
  #
  cloneAurAndCompile perl-file-rename
  cloneAurAndCompile icecat
  # google-chrome
  if [ "$browserSelect" = "0" ]; then
    cloneAurAndCompile google-chrome
    cloneAurAndCompile gconf
    cloneAurAndCompile chromedriver
  else
    sudo pacman -Sy --noconfirm chromium
  fi

  # opera
  sudo pacman -Sy --noconfirm opera
  sudo pacman -Sy --noconfirm opera-ffmpeg-codecs
  cd || return
  mkdir -p ~/bin
  cd ~/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/operasoftware/operachromiumdriver/releases/latest | jq -r ".assets[] | select(.name | test(\"linux64\")) | .browser_download_url")"
  unzip operadriver_linux64.zip
  cp operadriver_linux64/operadriver .
  chmod +x operadriver
fi

# postman
if [ "$installPostman" = "y" ]; then
  cloneAurAndCompile postman-bin
fi

# jmeter
if [ "$installJmeter" = "y" ]; then
  cloneAurAndCompile jmeter
  cloneAurAndCompile jmeter-plugins-manager
fi

# Allure
if [ "$installAllure" = "y" ]; then
  cloneAurAndCompile allure-commandline
fi

# SchemaGuru
if [ "$installSchemaGuru" = "y" ]; then
  cd ~/bin || return
  curl -OL "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | grep "tag_name" | awk '{print "https://github.com/snowplow/schema-guru/archive/" substr($2, 2, length($2)-3) ".zip"}')"
fi

# android
if [ "$installAndroidTools" = "y" ]; then
  echo "Installing Android AUR packages..."
  cloneAurAndCompile android-sdk
  cloneAurAndCompile android-sdk-platform-tools
  cloneAurAndCompile android-sdk-build-tools
  cloneAurAndCompile android-platform
  #cloneAurAndCompile android-ndk
  cloneAurAndCompile android-studio
  #cloneAurAndCompile android-emulator
  cloneAurAndCompile scrcpy

  {
    echo "export ANDROID_HOME=/opt/android-sdk/"
    echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
    echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools"
  }>>~/.bashrc

  # Relogin or source this file to add android emulator to user path
  source /etc/profile

  echo "Installing Android AUR packages... DONE"
fi
echo "installing AUR packages... DONE"

# appium
if [ "$installAppiumTools" = "y" ]; then
  echo "installing appium..."
  sudo pacman -Sy --noconfirm --needed npm cmake
  sudo pacman -Sy --noconfirm --needed opencv
  sudo npm install -g appium --unsafe-perm=true --allow-root
  sudo npm install -g appium-doctor
  #sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
  npm install wd
  cd || return
  mkdir -p ~/bin
  cd ~/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
  chmod +x *.AppImage
  echo "installing appium... DONE"
fi

# forensic tools
if [ "$installForensicTools" = "y" ]; then
  cloneAurAndCompile scalpel-git
  cloneAurAndCompile guymager
  #cloneAurAndCompile sleuthkit-java
  #cloneAurAndCompile autopsy
  #cloneAurAndCompile dff-git
fi

echo "Cleaning temporary data... "
for dir in ~/aur/*
do
    cd "$dir" || exit
    CURRENT_DIR=$(basename "$PWD")
    rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
done
echo "Cleaning temporary data... DONE"

echo "installing AUR packages... DONE"

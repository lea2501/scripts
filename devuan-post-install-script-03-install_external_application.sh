#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

options=(y n)
read -rp "Install extra tools?: (Y|n)" installExtraTools
if [[ " "${options[@]}" " != *" $installExtraTools "* ]]; then
  echo "$installExtraTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install basic tools?: (Y|n)" installBasicTools
if [[ " "${options[@]}" " != *" $installBasicTools "* ]]; then
  echo "$installBasicTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install private browsers?: (y|N)" installPrivateBrowsers
if [[ " "${options[@]}" " != *" $installPrivateBrowsers "* ]]; then
  echo "$installPrivateBrowsers: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
#read -rp "Install testing browsers (Chrome|Firefox|Opera)?: (Y|n)" installTestingBrowsers
#if [[ " "${options[@]}" " != *" $installTestingBrowsers "* ]]; then
#  echo "$installTestingBrowsers: not recognized. Valid options are:"
#  echo "${options[@]/%/,}"
#  exit 1
#fi
#read -rp "Install postman?: (Y|n)" installPostman
#if [[ " "${options[@]}" " != *" $installPostman "* ]]; then
#  echo "$installPostman: not recognized. Valid options are:"
#  echo "${options[@]/%/,}"
#  exit 1
#fi
read -rp "Install jmeter?: (Y|n)" installJmeter
if [[ " "${options[@]}" " != *" $installJmeter "* ]]; then
  echo "$installJmeter: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
#read -rp "Install allure?: (Y|n)" installAllure
#if [[ " "${options[@]}" " != *" $installAllure "* ]]; then
#  echo "$installAllure: not recognized. Valid options are:"
#  echo "${options[@]/%/,}"
#  exit 1
#fi
read -rp "Install schema guru?: (Y|n)" installSchemaGuru
if [[ " "${options[@]}" " != *" $installSchemaGuru "* ]]; then
  echo "$installSchemaGuru: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install Android tools?: (Y|n)" installAndroidTools
if [[ " "${options[@]}" " != *" $installAndroidTools "* ]]; then
  echo "$installAndroidTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install Appium tools?: (Y|n)" installAppiumTools
if [[ " "${options[@]}" " != *" $installAppiumTools "* ]]; then
  echo "$installAppiumTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install forensic tools?: (y|N)" installForensicTools
if [[ " "${options[@]}" " != *" $installForensicTools "* ]]; then
  echo "$installForensicTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi

#if [ "$installTestingBrowsers" = "y" ]; then
#  echo "Please select browser package to install:"
#  echo "    0) Google Chrome"
#  echo "    1) Chromium"
#  read -rp "0-1: " browserSelect
#
#  browserOptions=(0 1)
#  if [[ " "${browserOptions[@]}" " != *" $browserSelect "* ]]; then
#    echo "$browserSelect: not recognized. Valid options are:"
#    echo "${browserOptions[@]/%/,}"
#    exit 1
#  fi
#fi

echo "installing packages..."
mkdir -p ~/src
if [ "$installExtraTools" = "y" ]; then
  cd ~/src || return
  if [ ! -d "st" ] ; then
    git clone https://git.suckless.org/st
    cd st || return
  else
    cd st || return
    git pull
  fi
  cp config.def.h config.def.h.bak
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/st/config.def.h"
  mv config.h config.def.h
  sudo make clean install

  cd ~/src || return
  if [ ! -d "dwm" ] ; then
    git clone https://git.suckless.org/dwm
    cd dwm || return
  else
    cd dwm || return
    git pull
  fi
  cp config.def.h config.def.h.bak
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/dwm/config.h"
  mv config.h config.def.h
  sudo make clean install

  cd ~/src || return
  if [ ! -d "slstatus-git" ] ; then
    git clone https://git.suckless.org/slstatus
    cd slstatus || return
  else
    cd slstatus || return
    git pull
  fi
  cp config.def.h config.def.h.bak
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/slstatus-git/config.h"
  mv config.h config.def.h
  sudo make clean install
fi

if [ "$installBasicTools" = "y" ]; then
  # bash-git-prompt
  #cloneAurAndCompile tsmuxer-git

  cd ~/src || return
  if [ ! -d "bash-git-prompt" ] ; then
    git clone https://github.com/magicmonty/bash-git-prompt.git
    cd bash-git-prompt || return
  else
    cd bash-git-prompt || return
    git pull
  fi
  #sudo make clean install

  #cloneAurAndCompile vim-gnupg

  cd ~/src || return
  if [ ! -d "vscodium" ] ; then
    git clone https://github.com/VSCodium/vscodium.git
    cd vscodium || return
  else
    cd vscodium || return
    git pull
  fi
  #sudo make clean install

  #cloneAurAndCompile icaclient
  #mkdir -p "$HOME"/.ICAClient/cache
  #cp /opt/Citrix/ICAClient/config/{All_Regions,Trusted_Region,Unknown_Region,canonicalization,regions}.ini "$HOME"/.ICAClient/
fi

if [ "$installPrivateBrowsers" = "y" ]; then
  apt install -y firefox-esr
  apt install -y surf
  apt install -y chromium
fi

if [ "$installTestingBrowsers" = "y" ]; then
  # firefox
  #sudo pacman -Sy --noconfirm firefox geckodriver
  apt install -y firefox
  # google-chrome
  # TODO Incomplete from here
  if [ "$browserSelect" = "0" ]; then
    #cloneAurAndCompile google-chrome
    #cloneAurAndCompile gconf
    #cloneAurAndCompile chromedriver
  else
    apt install -y chromium
  fi

  # opera
  #sudo pacman -Sy --noconfirm opera
  #sudo pacman -Sy --noconfirm opera-ffmpeg-codecs
  #cd || return
  #mkdir -p ~/bin
  #cd ~/bin || return
  #curl -O -L "$(curl -s https://api.github.com/repos/operasoftware/operachromiumdriver/releases/latest | jq -r ".assets[] | select(.name | test(\"linux64\")) | .browser_download_url")"
  #unzip operadriver_linux64.zip
  #cp operadriver_linux64/operadriver .
  #chmod +x operadriver
fi

# postman
#if [ "$installPostman" = "y" ]; then
#  #cloneAurAndCompile postman-bin
#fi

# jmeter
if [ "$installJmeter" = "y" ]; then
  export JMETER_VERSION="5.4.1"
  export JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
  export JMETER_BIN	${JMETER_HOME}/bin
  export JMETER_DOWNLOAD_URL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

  apt-get update && \
  apt-get install -qq -y curl unzip && \
  mkdir -p /tmp/dependencies && \
  curl -L --silent ${JMETER_DOWNLOAD_URL} > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz && \
  mkdir -p /opt && \
  tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt && \
  rm -rf /tmp/dependencies

  # Set global PATH such that "jmeter" command is found
  {
    echo "export PATH=$PATH:$JMETER_BIN"
  }>>~/.bashrc
  source ~/.bashrc
fi

# Allure
#if [ "$installAllure" = "y" ]; then
#  #cloneAurAndCompile allure-commandline
#fi

# SchemaGuru
if [ "$installSchemaGuru" = "y" ]; then
  mkdir -p ~/bin
  cd ~/bin || return
  #curl -OL "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | grep "tag_name" | awk '{print "https://github.com/snowplow/schema-guru/archive/" substr($2, 2, length($2)-3) ".zip"}')"
  curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
  unzip schema_guru_0.6.2.zip
fi

# android
if [ "$installAndroidTools" = "y" ]; then
  echo "Installing Android packages..."
  sudo apt install -y adb
  sudo apt install -y android-sdk
  sudo apt install -y android-sdk-platform-tools
  sudo apt install -y android-sdk-build-tools
  #sudo apt install -y scrcpy #available in testing and sid for now

  #{
  #  echo "export ANDROID_HOME=/opt/android-sdk/"
  #  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
  #  echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools"
  #}>>~/.bashrc
  # Relogin or source this file to add android emulator to user path
  #source /etc/profile
  echo "Installing Android packages... DONE"
fi
echo "installing packages... DONE"

# appium
if [ "$installAppiumTools" = "y" ]; then
  echo "installing appium..."
  sudo apt install -y npm cmake
  sudo apt install -y opencv
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
  sudo apt install -y scalpel
  sudo apt install -y guymager
  #sudo apt install -y forensics-all
fi

echo "Cleaning temporary data... "
for dir in ~/src/*
do
    cd "$dir" || exit
    CURRENT_DIR=$(basename "$PWD")
    rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
done
echo "Cleaning temporary data... DONE"

echo "installing packages... DONE"
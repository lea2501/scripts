#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

read -rp "Install extra tools?: (y|n)" installExtraTools
read -rp "Install basic tools?: (y|n)" installBasicTools
read -rp "Install web browsers?: (y|n)" installBrowsers
read -rp "Install postman?: (y|n)" installPostman
read -rp "Install jmeter?: (y|n)" installJmeter
read -rp "Install allure?: (y|n)" installAllure
read -rp "Install schema guru?: (y|n)" installSchemaGuru
read -rp "Install Android tools?: (y|n)" installAndroidTools
read -rp "Install Appium tools?: (y|n)" installAppiumTools
read -rp "Install forensic tools?: (y|n)" installForensicTools

# AUR packages
echo "installing AUR packages..."

echo "Creating user 'aur' directory..."
mkdir -p ~/aur
echo "Creating user 'aur' directory... DONE"

echo "installing AUR packages..."
if [ "$installExtraTools" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/st.git
  cd st || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/dwm.git
  cd dwm || return
  makepkg -sic --noconfirm
fi

if [ "$installBasicTools" = "y" ]; then
  # bash-git-prompt
  cd ~/aur || return
  git clone https://aur.archlinux.org/bash-git-prompt.git
  cd bash-git-prompt || return
  makepkg -sic --noconfirm
  cd || return

  # icaclient (intranet)
  cd ~/aur || return
  git clone https://aur.archlinux.org/icaclient.git
  cd icaclient || return
  makepkg -sic --noconfirm
  mkdir -p $HOME/.ICAClient/cache
  cp /opt/Citrix/ICAClient/config/{All_Regions,Trusted_Region,Unknown_Region,canonicalization,regions}.ini $HOME/.ICAClient/
fi

if [ "$installBrowsers" = "y" ]; then
  # icecat
  #cd ~/aur || return
  #git clone https://aur.archlinux.org/perl-file-rename.git
  #cd perl-file-rename || return
  #makepkg -sic --noconfirm
  #cd ~/aur || return
  #git clone https://aur.archlinux.org/icecat.git
  #cd icecat || return
  #makepkg -sic --noconfirm

  # google-chrome
  cd ~/aur || return
  git clone https://aur.archlinux.org/google-chrome.git
  cd google-chrome || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/gconf.git
  cd gconf || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/chromedriver.git
  cd chromedriver || return
  makepkg -sic --noconfirm
  cd || return

  # opera
  sudo pacman -Sy --noconfirm opera
  sudo pacman -Sy --noconfirm opera-ffmpeg-codecs
  cd || return
  mkdir -p ~/bin
  cd ~/bin || return
  curl -O -L $(curl -s https://api.github.com/repos/operasoftware/operachromiumdriver/releases/latest | jq -r ".assets[] | select(.name | test(\"linux64\")) | .browser_download_url")
  unzip operadriver_linux64.zip
  cp operadriver_linux64/operadriver .
  chmod +x operadriver
fi

# postman
if [ "$installPostman" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/postman-bin.git
  cd postman-bin || return
  makepkg -sic --noconfirm
fi

# jmeter
if [ "$installJmeter" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/jmeter.git
  cd jmeter || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/jmeter-plugins-manager.git
  cd jmeter-plugins-manager || return
  makepkg -sic --noconfirm
fi

# Allure
if [ "$installAllure" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/allure-commandline.git
  cd allure-commandline || return
  makepkg -sic --noconfirm
fi

# SchemaGuru
if [ "$installSchemaGuru" = "y" ]; then
  cd ~/bin || return
  curl -OL $(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | grep "tag_name" | awk '{print "https://github.com/snowplow/schema-guru/archive/" substr($2, 2, length($2)-3) ".zip"}')
fi

# android
if [ "$installAndroidTools" = "y" ]; then
  echo "Installing Android AUR packages..."
  cd ~/aur || return
  git clone https://aur.archlinux.org/android-sdk.git
  cd android-sdk || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/android-sdk-platform-tools.git
  cd android-sdk-platform-tools || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/android-sdk-build-tools.git
  cd android-sdk-build-tools || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/android-platform.git
  cd android-platform || return
  makepkg -sic --noconfirm
  #cd ~/aur || return
  #git clone https://aur.archlinux.org/android-ndk.git
  #cd android-ndk || return
  #makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/android-studio.git
  cd android-studio || return
  makepkg -sic --noconfirm
  #cd ~/aur || return
  #git clone https://aur.archlinux.org/android-emulator.git
  #cd android-emulator || return
  #makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/scrcpy.git
  cd scrcpy || return
  makepkg -sic --noconfirm
  cd || return

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
  curl -O -L $(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")
  chmod +x *.AppImage
  echo "installing appium... DONE"
fi

# forensic tools
if [ "$installForensicTools" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/scalpel-git.git
  cd scalpel-git || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/guymager.git
  cd guymager || return
  makepkg -sic --noconfirm

#  cd ~/aur || return
#  git clone https://aur.archlinux.org/sleuthkit-java.git
#  cd sleuthkit-java || return
#  makepkg -sic --noconfirm
#
#  cd ~/aur || return
#  git clone https://aur.archlinux.org/autopsy.git
#  cd autopsy || return
#  makepkg -sic --noconfirm

#  cd ~/aur || return
#  git clone https://aur.archlinux.org/dff-git.git
#  cd dff-git || return
#  makepkg -sic --noconfirm
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
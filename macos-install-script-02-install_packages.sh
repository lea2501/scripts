#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

read -rp "Install brew tool?: (y|n)" installBrew
read -rp "Install system tools?: (y|n)" installSystemTools
read -rp "Install development tools?: (y|n)" installDevelTools
read -rp "Install multimedia tools?: (y|n)" installMultimediaTools
read -rp "Install extra tools?: (y|n)" installExtraTools
read -rp "Install network tools?: (y|n)" installNetworkTools
read -rp "Install misc tools?: (y|n)" installMiscTools
read -rp "Install Android tools?: (y|n)" installAndroidTools
read -rp "Install Appium tools?: (y|n)" installAppiumTools
read -rp "Install emulation tools?: (y|n)" installEmulationTools
read -rp "Install Docker?: (y|n)" installDocker

# Brew repository
if [ "$installBrew" = "y" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" </dev/null
  brew tap homebrew/cask
fi

if [ "$installSystemTools" = "y" ]; then
  brew install -q tmux
  brew install -q vim
  brew install -q nano
  brew install -q dos2unix
  brew install -q bash-completion
  brew install -q htop
  brew install -q findutils
fi

if [ "$installDevelTools" = "y" ]; then
  brew install -q cmake
  brew install -q gradle
  brew install -q maven
  brew install -q npm
  brew install -q jq
  brew install -q git
  brew install -q subversion
  brew install -q groovy
  brew install -q kotlin
  brew install -q allure
  #brew install -q homebrew/cask-versions/adoptopenjdk8
  brew install -q openjdk@8
  sudo ln -sfn /usr/local/opt/openjdk@8/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk
  brew install -q openjdk@11
  sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
  echo 'export PATH="/usr/local/opt/openjdk@11/bin:$PATH"' >> "$HOME"/.bash_profile
  brew install -q geany
  brew install -q intellij-idea-ce
fi

# multimedia
if [ "$installMultimediaTools" = "y" ]; then
  brew install -q flac faac opus-tools vorbis-tools wavpack
  brew install -q mpv
  brew install -q ffmpeg
  brew install -q sox
  brew install -q shntool
  brew install -q libdvdcss
  brew install -q lsdvd
  brew install -q vlc
fi

# extra tools
if [ "$installExtraTools" = "y" ]; then
  brew install -q moc
  brew install -q mkcue
  brew install -q avidemux
  brew install -q lynx
  brew install -q w3m
  brew install -q elinks
  brew install -q rtorrent
  brew install -q detox
  brew install -q midnight-commander
  brew install -q xquartz
  brew install -q mupdf
fi

# net
if [ "$installNetworkTools" = "y" ]; then
  brew install -q curl
  brew install -q wget
  brew install -q axel
  brew install -q firefox
  brew install -q geckodriver
  brew install -q google-chrome
  brew install -q chromedriver
  brew install -q opera
  brew install -q operadriver
  brew install -q jmeter
  brew install -q postman
  brew install -q tigervnc-viewer
  brew install -q openconnect
  brew install -q ngrok
fi

# tools
if [ "$installMiscTools" = "y" ]; then
  brew install -q jq
  brew install -q osxfuse
  brew install -q ntfs-3g
  brew install -q rsync
  brew install -q clamav
  brew install -q freerdp
  brew install -q rdesktop
  brew install -q libreoffice
  brew install -q cabextract unarj p7zip zip unzip gnu-tar bzip2 gzip
fi

# SchemaGuru
if [ "$installSchemaGuru" = "y" ]; then
  cd || return
  mkdir -p ~/bin
  cd ~/bin || return
  curl -OL $(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | grep "tag_name" | awk '{print "https://github.com/snowplow/schema-guru/archive/" substr($2, 2, length($2)-3) ".zip"}')
fi

# android
if [ "$installAndroidTools" = "y" ]; then
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
fi

# appium
if [ "$installAppiumTools" = "y" ]; then
  echo "installing appium..."
  brew install -q libimobiledevice
  brew install -q ios-deploy
  brew install -q npm cmake
  brew install -q carthage
  sudo npm install -g appium --unsafe-perm=true --allow-root
  sudo npm install -g appium-doctor
  #sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
  npm install wd
  cd || return
  mkdir -p ~/bin
  cd ~/Downloads || return
  curl -OL $(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\".dmg\")) | .browser_download_url") --output appium-desktop-latest.out
  open ~/Downloads
  read -p "Press enter key after installing appium-desktop"
  echo "installing appium... DONE"
fi

if [ "$installDocker" = "y" ]; then
  echo "Installing Docker requires to manually install the application."
  echo "After downloading please install manually"
  cd ~/Downloads || return
  curl -OL "https://desktop.docker.com/mac/stable/Docker.dmg"
  open "Docker.dmg"
  read -p "Press enter to continue after Docker installation..."
  rm "Docker.dmg"
fi

# emulators
if [ "$installEmulationTools" = "y" ]; then
  brew install -q virtualbox
  brew install -q vagrant
  brew install -q vagrant-manager
  vagrant plugin install vagrant-vbguest
fi
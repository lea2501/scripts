#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

username=$USER

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

options=(Y y N n)

# Section: Create xinitrc
read -rp "Install brew?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" </dev/null
  brew tap homebrew/cask
  echo "Installing brew... DONE"
fi

# Section: Install common packages
read -rp "Install common packages?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  # system
  brew install -q tmux vim nano dos2unix bash-completion htop coreutils findutils
  
  # devel
  brew install -q cmake gradle maven npm jq git subversion groovy kotlin allure openjdk@8 openjdk@11 geany intellij-idea-ce

  # multimedia
  brew install -q flac faac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool libdvdcss lsdvd vlc
  
  # extra tools
  brew install -q moc mkcue avidemux lynx w3m rtorrent detox midnight-commander xquartz mupdf
  
  # network tools
  brew install -q curl wget axel firefox geckodriver google-chrome chromedriver jmeter postman tigervnc-viewer openconnect ngrok
  
  # tools
  brew install -q osxfuse ntfs-3g rsync clamav freerdp rdesktop libreoffice cabextract unarj p7zip zip unzip gnu-tar bzip2 gzip
  
  ## emulators
  #brew install -q virtualbox vagrant vagrant-manager
  
  # openjdk
  sudo ln -sfn /usr/local/opt/openjdk@8/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk
  sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
fi

# Section: Install packages 'testing tools'
read -rp "Install packages 'testing tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing packages 'tools'..."
  # SchemaGuru
  mkdir -p ~/bin
  cd ~/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
  unzip schema_guru_0.6.2.zip
  echo "Installing packages 'tools'... DONE"
fi

# Section: Install packages 'android tools'
read -rp "Install packages 'android tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing packages 'android tools'..."
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
  echo "Installing packages 'android tools'... DONE"
fi

# Section: Install packages 'appium'
read -rp "Install packages 'appium'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "installing appium..."
  brew install -q libimobiledevice
  brew install -q ios-deploy
  brew install -q npm cmake
  brew install -q carthage
  sudo npm install -g appium --unsafe-perm=true --allow-root
  sudo npm install -g appium-doctor
  #sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
  npm install wd

  # appium-desktop
  cd || return
  mkdir -p ~/Downloads
  cd ~/Downloads || return
  curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\".dmg\")) | .browser_download_url")"
  open ~/Downloads
  read -p "Press enter key after installing appium-desktop"
  echo "installing appium... DONE"
fi

# Section: Install packages 'docker'
read -rp "Install packages 'docker'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "installing docker..."
  echo "Installing docker requires to manually install the application."
  echo "After downloading please install manually"
  mkdir -p ~/Downloads
  cd ~/Downloads || return
  curl -OL "https://desktop.docker.com/mac/stable/Docker.dmg"
  open "Docker.dmg"
  read -p "Press enter to continue after Docker installation..."
  rm "Docker.dmg"
  echo "installing docker... DONE"
fi

# Section: Generate ssh keys
read -rp "Generate ssh keys?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Generating ssh keys..."
  echo "In a web browser, create or access your personal Github account (Optional):"
  echo "  1) In a new tab, open https://github.com in a web browser."
  echo "  2) Access with your personal Github credentials or create a new one."
  echo "  3) Access to https://github.com/settings/keys and leave it open"
  echo ""
  echo -e "\033[33;5m Don't close Github page when finished... \033[0m"
  echo ""
  read -rp "Press enter when finish to create ssh keys..."

  echo "Generating ssh key in ~/.ssh/id_rsa.pub file..."
  cat /dev/zero | ssh-keygen -q -N ""
  echo "Generating ssh key in ~/.ssh/id_rsa.pub file... DONE"

  echo "Copying content of '~/.ssh/id_rsa.pub' file to the clipboard..."
  xclip -sel c <~/.ssh/id_rsa.pub
  echo "Copying content of '~/.ssh/id_rsa.pub' file to the clipboard... DONE"
  echo ""
  echo -e "\033[33;5m If you copy other thing to the clipboard, here is your ssh public key, ready to copy again... \033[0m"
  echo ""
  cat ~/.ssh/id_rsa.pub
  echo ""

  echo "Add SSH keys to Github account (Optional):"
  echo "  1) Access ssh-keys settings in https://github.com/settings/keys"
  echo "  2) Paste the key copied from ~/.ssh/id_rsa.pub and press 'Add key' button."
  echo ""
  read -rp "Press enter when finish to continue..."
  echo "Generating ssh keys... DONE"
fi

# Section: Configure Git
read -rp "Configure Git?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Configuring Git..."
  read -rp "Enter Git user email: " gitUserEmail
  git config --global user.email "$gitUserEmail"
  read -rp "Enter Git user name: " gitUserName
  git config --global user.name "$gitUserName"
  git config --global pull.rebase false
  echo "Configuring Git... DONE"
fi

# Section: Set java default version
read -rp "Set java default version?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Setting java default version..."
  echo "Setting JAVA HOME..."
  export JAVA_HOME=$(/usr/libexec/java_home -v11)
  export PATH=$JAVA_HOME/bin:$PATH
  echo "Setting JAVA HOME... DONE"
  echo "Setting java default version... DONE"
fi

# Section: Configure and start docker
read -rp "Configure and start docker?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Open Docker from Finder > Applications and start Docker daemon..."
  echo "  Also, in 'Preferences' > 'Resources' > 'Memory' set needed Memory amount"
  echo "  (Selenium jobs limit is between 4Gb and 6Gb each)"
  read -p "Press enter to continue"
  echo "Open Docker from Finder > Applications and start Docker daemon... DONE"

  # setup docker
  echo "Setup docker for normal user usage..."
  sudo groupadd docker || true
  sudo gpasswd -a $USER docker || true
  echo "Setup docker for normal user usage... DONE"
fi

# Section: Update clamav antivirus
read -rp "Update clamav antivirus?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Updating clamav virus definition database..."
  cp /usr/local/etc/clamav/freshclam.conf.sample /usr/local/etc/clamav/freshclam.conf
  sed -i '' 's/Example/#Example/g' /usr/local/etc/clamav/freshclam.conf
  freshclam
  echo "Updating clamav virus definition database... Done"
fi

# Section: Set PATH in ~/bashrc file
read -rp "Set PATH in ~/bashrc file?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Creating user 'bin' directory..."
  cd || return
  mkdir -p ~/bin
  echo "PATH=\$PATH:~/bin/" >>~/.profile
  source ~/.profile
  echo "Creating user 'bin' directory... DONE"
fi



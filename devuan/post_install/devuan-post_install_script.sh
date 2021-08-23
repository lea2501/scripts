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
read -rp "Create .xinit file in user home directory?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing xorg packages..."
  echo ""
  sudo apt-get -y install xorg
  echo "Installing xorg packages... DONE"

  echo "Creating ~/.xinitrc file..."
  cp /etc/X11/xinit/xinitrc ~/.xinitrc
  echo "Creating ~/.xinitrc file... DONE"
fi

# Section: Disable login manager
read -rp "Disable login manager?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Disabling login manager..."
  read -rp "Enter used init sistem name (sysvinit|openrc|runit)" init_system
  read -rp "Enter used login manager name (lightdm|sddm|slim|xdm)" login_manager
  if [ "$init_system" = "sysvinit" ]; then
    sudo invoke-rc.d "$login_manager" stop
  fi
  if [ "$init_system" = "openrc" ]; then
    sudo rc-update del "$login_manager"
  fi
  if [ "$init_system" = "runit" ]; then
    sudo rm /var/service/"$login_manager"
  fi
  echo "Disabling login manager... DONE"
fi

# Section: Get personal dotfiles
read -rp "Get personal dotfiles backups from Github?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Getting backup dotfiles from github..."
  cd || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xinitrc"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xresources"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xdefaults"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.tmux.conf"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.vimrc"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xbindkeysrc"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.picom.conf"
  mkdir -p ~/.prboom-plus/ && cd ~/.prboom-plus/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.prboom-plus/prboom-plus.cfg"
  cd || return
  mkdir -p ~/.config/gzdoom/ && cd ~/.config/gzdoom/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom.ini"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex.ini"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex_mouseonly.ini"
  cd || return
  mkdir -p ~/.config/i3/ && cd ~/.config/i3/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3/config"
  cd || return
  mkdir -p ~/.config/i3status/ && cd ~/.config/i3status/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3status/config"
  cd || return
  mkdir -p ~/.config/mc/ && cd ~/.config/mc/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/hotlist"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/ini"
  cd || return
  mkdir -p ~/.config/mpv/ && cd ~/.config/mpv/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/input.conf"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/mpv.conf"
  cd || return
  mkdir -p ~/.config/geany/colorschemes/ && cd ~/.config/geany/colorschemes/ || return
  curl -OL "https://raw.github.com/geany/geany-themes/master/colorschemes/bespin.conf"
  cd || return
  echo "Getting backup dotfiles from github... DONE"
fi

# Section: Install common packages
read -rp "Install common packages?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Updating system repositories and packages..."
  sudo apt update
  sudo apt full-upgrade -y
  echo "Updating system repositories and packages... DONE"
  echo "installing packages..."
  cd || return
  # system
  sudo apt-get -y install build-essential tmux vim nano udisks2 suckless-tools brightnessctl brightness-udev dos2unix exfat-utils xclip autocutsel xosd-bin
  sudo apt-get -y install ttf-bitstream-vera fonts-dejavu fonts-inconsolata fonts-liberation
  sudo apt-get -y install usbutils udftools bash-completion htop findutils acpi cpufreqd lm-sensors ntp alsa-tools alsa-utils pass xdotool tree

  # pulseaudio
  sudo apt-get -y install pulseaudio pavucontrol pulseaudio-alsa

  # devel
  sudo apt-get -y install cmake openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre maven gradle npm
  sudo apt-get -y install jq git subversion groovy docker.io mariadb-server mariadb-client geany geany-plugins
  sudo apt-get -y install adb android-sdk android-sdk-build-tools android-sdk-platform-tools fastboot

  # multimedia
  sudo apt-get -y install flac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool lsdvd

  # extra tools
  sudo apt-get -y install moc lynx w3m newsboat rtorrent amule youtube-dl
  sudo apt-get -y install pcmanfm detox scrot mc hdparm lshw
  sudo apt-get -y install  mcomix qpdf zathura zathura-pdf-poppler zathura-djvu zathura-ps zathura-cb mupdf mupdf-tools

  # forensic tools
  sudo apt-get -y install foremost testdisk sleuthkit scalpel guymager

  # images
  sudo apt-get -y install feh geeqie gimp imagemagick

  # net
  sudo apt-get -y install curl axel tigervnc-viewer openconnect network-manager network-manager-openconnect samba

  # tools
  sudo apt-get -y install ntfs-3g rsync clamav gparted rdesktop libreoffice keepassxc cabextract arj unrar-free p7zip-full unace unzip zip tar xarchiver galculator

  # emulators
  sudo apt-get -y install qemu qemu-kvm qemu-system-x86 qemu-utils
  
  echo "installing packages... DONE"
fi

# Section: Install external packages 'minimal tools'
read -rp "Install external packages 'minimal tools'?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing external packages 'minimal tools'..."
  sudo apt-get -y install stterm
  sudo apt-get -y install cwm
  cd || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.cwmrc"
  echo "Installing external packages 'minimal tools'... DONE"
fi

# Section: Install external packages 'other browsers'
read -rp "Install external packages 'other browsers'?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing external packages 'other browsers'..."
  sudo apt-get -y install chromium
  sudo apt-get -y install firefox-esr
  sudo apt-get -y install surf
  echo "Installing external packages 'other browsers'... DONE"
fi

# Section: Install external packages 'tools'
read -rp "Install external packages 'tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing external packages 'tools'..."
  cloneRepo bash-git-prompt https://github.com/magicmonty/bash-git-prompt.git
  echo "Installing external packages 'tools'... DONE"
fi

# Section: Install external packages 'testing browsers'
read -rp "Install external packages 'testing browsers'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing external packages 'testing browsers'..."
  sudo apt-get -y install chromium chromium-driver
  sudo apt-get -y install firefox-esr
  echo "Installing external packages 'testing browsers'... DONE"
fi

# Section: Install external packages 'testing tools'
read -rp "Install external packages 'testing tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing external packages 'testing tools'..."
  # postman
  #mkdir -p ~/bin
  #cd ~/bin || return
  #curl -o "Postman-linux-x64.tar.gz" -L "https://dl.pstmn.io/download/latest/linux64"
  #sudo tar -xzf postman-linux-x64.tar.gz -C /opt
  #sudo ln -s /opt/Postman/Postman /usr/bin/postman
  #echo "[Desktop Entry]<br>Encoding=UTF-8<br>Name=Postman<br>Exec=/opt/Postman/app/Postman %U<br>Icon=/opt/Postman/app/resources/app/assets/icon.png<br>Terminal=false<br>Type=Application<br>Categories=Development;" > ~/.local/share/applications/Postman.desktop

  # postman
  mkdir -p ~/bin
  cd ~/bin || return
  curl -o "Postman-linux-x64.tar.gz" -L "https://dl.pstmn.io/download/latest/linux64"
  tar -xzvf Postman-linux-x64.tar.gz
  ln -s Postman/app/Postman postman

  # jmeter
  export JMETER_VERSION="5.4.1"
  export JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
  export JMETER_BIN="${JMETER_HOME}"/bin
  export JMETER_DOWNLOAD_URL=https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

  sudo apt-get update && \
  sudo apt-get install -qq -y curl unzip && \
  mkdir -p /tmp/dependencies && \
  curl -L --silent "${JMETER_DOWNLOAD_URL}" > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz && \
  sudo mkdir -p /opt && \
  sudo tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt && \
  rm -rf /tmp/dependencies

  # Set global PATH such that "jmeter" command is found
  {
    echo "export PATH=$PATH:$JMETER_BIN"
  }>>~/.bashrc
  source ~/.bashrc

  # Allure
  sudo apt-get -y install allure

  # SchemaGuru
  mkdir -p ~/bin
  cd ~/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
  unzip schema_guru_0.6.2.zip
  echo "Installing external packages 'testing tools'... DONE"
fi

# Section: Install external packages 'android tools'
read -rp "Install external packages 'android tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing Android packages..."
  sudo apt-get -y install adb
  sudo apt-get -y install android-sdk
  sudo apt-get -y install android-sdk-platform-tools
  sudo apt-get -y install android-sdk-build-tools
  #sudo apt-get -y install scrcpy #available in testing and sid for now

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
fi

# Section: Install external packages 'appium'
read -rp "Install external packages 'appium'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "installing appium..."
  sudo apt-get -y install npm cmake
  sudo apt-get -y install node-opencv
  sudo npm install -g appium --unsafe-perm=true --allow-root
  sudo npm install -g appium-doctor
  #sudo npm install -g opencv4nodejs --unsafe-perm=true --allow-root
  npm install wd

  # appium-desktop
  cd || return
  mkdir -p ~/bin
  cd ~/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url")"
  chmod +x *.AppImage
  echo "installing appium... DONE"
fi

# Section: Install external packages 'development'
read -rp "Install external packages 'development'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "installing development tools..."
  # intellij
  mkdir -p ~/bin
  cd ~/bin || return
  curl -OL "https://download-cf.jetbrains.com/idea/ideaIC-2020.1.tar.gz"
  tar -zxvf ideaIC-*.tar.gz
  sudo mkdir /opt/idea/
  sudo chmod 777 /opt/idea/
  mv idea-*/* /opt/idea/

  # Set global PATH such that "idea" command is found
  {
    echo "export PATH=$PATH:/opt/idea/bin"
  }>>~/.bashrc
  source ~/.bashrc

  # vscodium
  mkdir -p ~/bin
  cd ~/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/VSCodium/vscodium/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url" | head
  -n 1)"
  echo "installing development tools... DONE"
fi

# Section: Create user aliases in bash_aliases file
read -rp "Create user aliases in bash_aliases file?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Creating user aliases in ~/.bash_aliases file..."
  cd || return

  {
    echo "alias syncthing='syncthing -no-browser'"
    echo "alias getBatt='upower -i /org/freedesktop/UPower/devices/battery_BAT0'"
    echo "alias getBattBrief='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E \"state|time\ to\ |percentage\"'"
    echo "alias getBattPercent=\"upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep 'percentage' | awk '{print \$2}'\"":
    echo "alias getVulnerabilities='grep -RHe \"^\" /sys/devices/system/cpu/vulnerabilities'"
    echo "alias getAudioMaster=\"amixer sget Master | grep 'Right:' | awk -F'[][]' '{print \$2}'\""
    echo "alias dim=\"echo \$(tput cols)x\$(tput lines)\""
    echo "alias systemstats='echo \"== Disks ==\" && df -h && echo \"== Memory ==\" && free -h && echo \"== CPU ==\" && cat /proc/cpuinfo | grep \"cpu MHz\" && echo \"== TEMP ==\" && sensors | grep \"°C\"'"
  } >>~/.bash_aliases

  {
    echo "if [ -f ~/.bash_aliases ]; then"
    echo "  . ~/.bash_aliases"
    echo "fi"
  } >>~/.bashrc

  source ~/.bashrc
  echo "Creating user aliases in ~/.bash_aliases file... DONE"
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

# Section: Apply fix for misbehaving java applications
read -rp "Apply fix for misbehaving java applications?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Apply fix for misbehaving java applications..."
  sudo echo "export _JAVA_AWT_WM_NONREPARENTING=1" | sudo tee -a /etc/profile.d/jre.sh
  #echo "export AWT_TOOLKIT=MToolkit" >> ~/.xinitrc
  #echo "wmname compiz"
  echo "Apply fix for misbehaving java applications... DONE"
fi

# Section: Set keyboard layout
read -rp "Set keyboard layout?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  cd || return
  echo "Set keyboard layout..."
  echo "setxkbmap -layout latam -variant deadtilde" >>~/.bash_profile
  echo "Set keyboard layout... DONE"
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

# Section: Clone personal repos
read -rp "Clone personal repos?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Creating ~/src directory..."
  mkdir -p ~/src
  echo "Creating ~/src directory... DONE"
  echo "Cloning Github repos..."
  cd ~/src || return
  git clone git@github.com:lea2501/dotfiles.git
  git clone git@github.com:lea2501/scripts.git
  echo "Cloning Github repos... DONE"
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
  sudo update-alternatives --config java
  java -version
  echo "Setting java default version... DONE"
fi

# Section: Start and configure services
read -rp "Start and configure services?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  read -rp "Enter used init sistem name (sysvinit|openrc|runit)" init_system

  # start docker
  echo "Enabling and starting docker service..."
  if [ "$init_system" = "sysvinit" ]; then
    sudo invoke-rc.d docker start
  fi
  if [ "$init_system" = "openrc" ]; then
    rc-update add docker default
    rc-service docker start
  fi
  if [ "$init_system" = "runit" ]; then
    #TODO
    #sudo rm /var/service/$login_manager
    echo ""
  fi
  echo "Enabling and starting docker service... DONE"

  # setup docker
  echo "Setup docker for normal user usage..."
  sudo groupadd docker || true
  sudo gpasswd -a $USER docker || true
  echo "Setup docker for normal user usage... DONE"

  ## start NTP
  #echo "Enabling and starting ntp service..."
  #if [ "$init_system" = "sysvinit" ]; then
  #  sudo invoke-rc.d ntp start
  #fi
  #if [ "$init_system" = "openrc" ]; then
  #  rc-update add ntp default
  #  rc-service ntp start
  #fi
  #if [ "$init_system" = "runit" ]; then
  #  #TODO
  #  #sudo rm /var/service/$login_manager
  #fi
  #echo "Enabling and starting ntp service... DONE"

  ## start SSH daemon
  #echo "Enabling and starting ntp service..."
  #if [ "$init_system" = "sysvinit" ]; then
  #  sudo invoke-rc.d sshd start
  #fi
  #if [ "$init_system" = "openrc" ]; then
  #  rc-update add sshd default
  #  rc-service sshd start
  #fi
  #if [ "$init_system" = "runit" ]; then
  #  #TODO
  #  #sudo rm /var/service/$login_manager
  #fi
  #echo "Enabling and starting ntp service... DONE"
fi

# Section: Enable Bash git prompt
read -rp "Enable Bash git prompt?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Enabling Bash git prompt..."

  {
    echo "if [ -f ~/src/bash-git-prompt/gitprompt.sh ]; then"
    echo "    # To only show the git prompt in or under a repository directory"
    echo "     GIT_PROMPT_ONLY_IN_REPO=1"
    echo "    # To use upstream's default theme"
    echo "     GIT_PROMPT_THEME=Default"
    echo "    source ~/src/bash-git-prompt/gitprompt.sh"
    echo "fi"
  }>>~/.bashrc
  source ~/.bashrc

  echo "Enabling Bash git prompt... DONE"
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
  sudo freshclam
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
  echo "PATH=\$PATH:~/bin/" >>~/.bashrc
  source ~/.bashrc
  echo "Creating user 'bin' directory... DONE"
fi



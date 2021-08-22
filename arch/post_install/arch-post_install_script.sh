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
  sudo pacman -Sy --noconfirm xorg xorg-xinit
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
  read -rp "Enter used login manager name (lightdm|sddm|slim|xdm)" login_manager
  sudo systemctl disable $login_manager
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

# Section: Remove asking sudo password
read -rp "Remove asking for sudo password?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Removing asking for sudo password for user..."
  echo "${username} ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
  echo "Removing asking for sudo password for user... DONE"
fi

# Section: Configure pacman settings
read -rp "Configure pacman settings?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Configuring standard pacman settings..."
  sudo cp /etc/pacman.conf /etc/pacman.conf.bak
  sudo cat /etc/pacman.conf | sudo sed -e "s/ILoveCandy/#ILoveCandy/" | sudo tee /etc/pacman.conf.edited
  sudo mv /etc/pacman.conf.edited /etc/pacman.conf
  sudo cat /etc/pacman.conf | sudo sed -e "s/#VerbosePkgLists/VerbosePkgLists/" | sudo tee /etc/pacman.conf.edited
  sudo mv /etc/pacman.conf.edited /etc/pacman.conf
  sudo cat /etc/pacman.conf | sudo sed -e "s/#ParallelDownloads/ParallelDownloads/" | sudo tee /etc/pacman.conf.edited
  sudo mv /etc/pacman.conf.edited /etc/pacman.conf
  echo "Configuring standard pacman settings... DONE"
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
  sudo pacman -Syu --noconfirm
  echo "Updating system repositories and packages... DONE"

  echo "installing packages..."
  cd || return
  # system
  echo \
    'pacman-contrib
base-devel
tmux
vi
vim
nano
udisks2
brightnessctl
dos2unix
exfatprogs
picom
terminus-font
xclip
autocutsel
xosd
ttf-bitstream-vera ttf-dejavu ttf-inconsolata ttf-liberation ttf-opensans
gnu-free-fonts
usbutils
udftools
bash-completion
htop
findutils
acpi
lm_sensors
ntp
alsa-plugins alsa-utils' >packages.txt
  # pulseaudio
  echo \
    'pulseaudio pavucontrol pulseaudio-alsa' >>packages.txt
  # devel
  echo \
    'cmake
jre-openjdk
jdk-openjdk
jdk8-openjdk
jdk11-openjdk
maven
gradle
npm
jq
git
subversion
groovy
intellij-idea-community-edition
kotlin
docker
mariadb mariadb-clients
geany geany-plugins
android-tools' >>packages.txt
  # multimedia
  echo \
    'flac faac mac opus-tools vorbis-tools wavpack
mpv
ffmpeg
sox
shntool
libdvdcss
lsdvd' >>packages.txt
  # extra tools
  echo \
    'wmname
moc
avidemux-qt
lynx
w3m
newsboat
rtorrent
amule
aria2
youtube-dl
dmenu
pcmanfm
detox
scrot
slock
mc
hdparm lshw
mcomix
qpdf
zathura zathura-pdf-mupdf
mupdf mupdf-tools' >>packages.txt
  # forensic tools
  echo \
    'foremost
testdisk
sleuthkit' >>packages.txt
  # images
  echo \
    'feh
geeqie
gimp
imagemagick' >>packages.txt
  # net
  echo \
    'curl
wget
axel
tigervnc
filezilla
openconnect
networkmanager-openconnect
samba' >>packages.txt
  # tools
  echo \
    'ntfs-3g
rsync
clamav
gparted
freerdp
rdesktop
libreoffice-still libreoffice-still-es
keepassxc
cabextract arj unrar p7zip unarj unace unzip zip tar
xarchiver
galculator' >>packages.txt
  # emulators
  echo \
    'qemu qemu-arch-extra' >>packages.txt
  #  virtualbox virtualbox-guest-utils libvirt virtualbox-host-dkms
  #  vagrant plugin install vagrant-vbguest

  sudo pacman -Sy --noconfirm --needed $(cat packages.txt)
  #rm packages.txt

  echo "installing packages... DONE"
fi

# Section: Install AUR packages 'other browsers'
read -rp "Install AUR packages 'other browsers'?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing AUR packages 'other browsers'..."
  cloneRepo paru
  makepkg -sic --noconfirm

  cloneRepo st
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/aur/st/config.def.h"
  makepkg -sic --noconfirm --skipinteg

  cloneRepo cwm
  makepkg -sic --noconfirm --skipinteg
  cd || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.cwmrc"

  # browsers
  echo \
    'chromium
firefox-esr-bin
surf
amfora
bombadillo
lagrange' >packages.txt

  paru -S $(cat packages.txt)
  echo "Installing AUR packages 'other browsers'... DONE"
fi

# Section: Install AUR packages 'tools'
read -rp "Install AUR packages 'tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing AUR packages 'tools'..."
  # tools
  echo \
    'bash-git-prompt
tsmuxer-git
vim-gnupg
vscodium-bin
scalpel-git
guymager' >packages.txt

  paru -S $(cat packages.txt)
  echo "Installing AUR packages 'tools'... DONE"
fi

# Section: Install AUR packages 'testing tools'
read -rp "Install AUR packages 'testing tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing AUR packages 'testing tools'..."
  # tools
  echo \
    'postman-bin
jmeter
jmeter-plugins-manager
allure-commandline' >packages.txt

  paru -S $(cat packages.txt)

  # schema guru
  mkdir -p ~/bin && cd ~/bin || return
  #curl -OL "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | grep "tag_name" | awk '{print "https://github.com/snowplow/schema-guru/archive/" substr($2, 2, length($2)-3) ".zip"}')"
  curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
  unzip schema_guru_0.6.2.zip
  echo "Installing AUR packages 'testing tools'... DONE"
fi

# Section: Install AUR packages 'testing browsers'
read -rp "Install AUR packages 'testing browsers'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing AUR packages 'testing browsers'..."
  # browsers
  echo \
    'firefox geckodriver
google-chrome
chromedriver' >packages.txt

  paru -S $(cat packages.txt)

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
  echo "Installing AUR packages 'testing browsers'... DONE"
fi

# Section: Install AUR packages 'android tools'
read -rp "Install AUR packages 'android tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing AUR packages 'android tools'..."
  # android
  echo \
    'android-sdk
android-sdk-platform-tools
android-sdk-build-tools
android-platform
scrcpy' >packages.txt

  paru -S $(cat packages.txt)

  {
    echo "export ANDROID_HOME=/opt/android-sdk/"
    echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
    echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools"
  }>>~/.bashrc

  # login again or source this file to add android emulator to user path
  source /etc/profile
  echo "Installing AUR packages 'android tools'... DONE"
fi

# Section: Install AUR packages 'appium'
read -rp "Install AUR packages 'appium'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Installing AUR packages 'appium'..."
  # appium
  sudo pacman -Sy --noconfirm --needed npm cmake
  sudo pacman -Sy --noconfirm --needed opencv
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
  echo "Installing AUR packages 'appium'... DONE"
fi

# Section: Clean temporary AUR files
read -rp "Clean temporary AUR files?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  echo "Clean temporary AUR files..."
  for dir in ~/aur/*
  do
      cd "$dir" || exit
      CURRENT_DIR=$(basename "$PWD")
      rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
  done
  echo "Clean temporary AUR files... DONE"
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
    echo "alias aur_update='for dir in ~/aur/*; do (cd \"\$dir\" && pwd && git pull); done'"
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
  sudo archlinux-java set java-11-openjdk
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
  # start docker
  echo "Enabling and starting docker service..."
  sudo systemctl enable docker
  sudo systemctl start docker
  echo "Enabling and starting docker service... DONE"

  # setup docker
  echo "Setup docker for normal user usage..."
  sudo groupadd docker || true
  sudo gpasswd -a $USER docker || true
  echo "Setup docker for normal user usage... DONE"

  # start NTP
  echo "Enabling and starting ntp service..."
  sudo systemctl enable ntpdate.service
  sudo systemctl start ntpdate.service
  echo "Enabling and starting ntp service... DONE"

  # start SSH daemon
  echo "Enabling and starting ntp service..."
  sudo systemctl enable sshd.service
  sudo systemctl start sshd.service
  echo "Enabling and starting ntp service... DONE"
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
    echo "if [ -f /usr/lib/bash-git-prompt/gitprompt.sh ]; then"
    echo "    # To only show the git prompt in or under a repository directory"
    echo "     GIT_PROMPT_ONLY_IN_REPO=1"
    echo "    # To use upstream's default theme"
    echo "     GIT_PROMPT_THEME=Default"
    echo "    # To use upstream's default theme, modified by arch maintainer"
    echo "    # GIT_PROMPT_THEME=Default_Arch"
    echo "    source /usr/lib/bash-git-prompt/gitprompt.sh"
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



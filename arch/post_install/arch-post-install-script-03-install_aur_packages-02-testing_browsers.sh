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

# firefox
sudo pacman -Sy --noconfirm firefox geckodriver

# google-chrome
cloneAurAndCompile google-chrome
cloneAurAndCompile gconf
cloneAurAndCompile chromedriver

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
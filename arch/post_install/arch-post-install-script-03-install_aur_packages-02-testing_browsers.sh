#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# browsers
echo \
  'firefox geckodriver
google-chrome
chromedriver' >>packages.txt

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
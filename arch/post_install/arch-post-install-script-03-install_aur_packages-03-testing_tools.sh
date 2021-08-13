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

# postman
cloneAurAndCompile postman-bin

# jmeter
cloneAurAndCompile jmeter
cloneAurAndCompile jmeter-plugins-manager

# Allure
cloneAurAndCompile allure-commandline

# SchemaGuru
cd ~/bin || return
curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
unzip schema_guru_0.6.2.zip

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

# tools
cloneAurAndCompile paru
cloneAurAndCompile bash-git-prompt
cloneAurAndCompile tsmuxer-git
cloneAurAndCompile vim-gnupg
cloneAurAndCompile vscodium-bin
#cloneAurAndCompile icaclient
#mkdir -p "$HOME"/.ICAClient/cache
#cp /opt/Citrix/ICAClient/config/{All_Regions,Trusted_Region,Unknown_Region,canonicalization,regions}.ini "$HOME"/.ICAClient/

# forensics
cloneAurAndCompile scalpel-git
cloneAurAndCompile guymager
#cloneAurAndCompile sleuthkit-java
#cloneAurAndCompile autopsy
#cloneAurAndCompile dff-git
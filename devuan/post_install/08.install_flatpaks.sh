#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get -y --fix-missing install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.google.Chrome
flatpak install flathub org.chromium.Chromium
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

#https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux&code=IIC

mkdir -p ~/bin
cd ~/bin || return
export INTELLIJ_VERSION=$(curl --silent "https://raw.githubusercontent.com/archlinux/svntogit-community/packages/intellij-idea-community-edition/trunk/PKGBUILD" | grep "pkgver=" | sed 's/pkgver=//')
export INTELLIJ_DOWNLOAD_URL="https://download-cf.jetbrains.com/idea/ideaIC-${INTELLIJ_VERSION}.tar.gz"

$su apt-get update -qq
$su apt-get install -qq -y curl

# Remove previous file
rm -rf ideaIC-"${INTELLIJ_VERSION}".tar.gz
# Download new version
curl -L --silent "${INTELLIJ_DOWNLOAD_URL}" > ideaIC-"${INTELLIJ_VERSION}".tar.gz
# Remove previous directory
rm -rf ideaIC-"${INTELLIJ_VERSION}"
# Remove previous symlink
rm -f idea
# Extract new version
tar -xvf ideaIC-"${INTELLIJ_VERSION}".tar.gz
mv idea-IC-* ideaIC-"${INTELLIJ_VERSION}"
# Create new symlink
ln -s ideaIC-"${INTELLIJ_VERSION}"/bin/idea.sh ~/bin/idea

# vscodium
mkdir -p ~/Applications
cd ~/Applications || return
curl -O -L "$(curl -s https://api.github.com/repos/VSCodium/vscodium/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url" | head -n 1)"

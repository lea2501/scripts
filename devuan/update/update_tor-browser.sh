#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

#https://www.torproject.org/download/

mkdir -p ~/bin
cd ~/bin || return

export TOR_BROWSER_VERSION=$(curl --silent "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=tor-browser" | grep "pkgver=" | sed 's/pkgver=//' | sed "s/'//g")
export TOR_BROWSER_FILENAME="tor-browser-linux64-${TOR_BROWSER_VERSION}_en-US.tar.xz"
export TOR_BROWSER_DOWNLOAD_URL="https://www.torproject.org/dist/torbrowser/${TOR_BROWSER_VERSION}/${TOR_BROWSER_FILENAME}"

$su apt-get update -qq
$su apt-get install -qq -y curl

# Remove previous file
rm -rf tor-browser-linux64-*_en-US.tar.xz
# Download new version
curl -OL "${TOR_BROWSER_DOWNLOAD_URL}"
# Remove previous directory
rm -rf tor-browser_en-US
# Remove previous symlink
rm -f tor-browser
# Extract new version
tar -xvf ${TOR_BROWSER_FILENAME}
# Create new symlink
ln -s ~/bin/tor-browser_en-US/Browser/start-tor-browser ~/bin/tor-browser

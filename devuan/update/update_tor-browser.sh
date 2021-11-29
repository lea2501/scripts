#!/bin/bash

# fail if any commands fails
set -e
# debug log
set -x

#https://www.torproject.org/download/

mkdir -p ~/bin
cd ~/bin || return

export TOR_BROWSER_VERSION="11.0"
export TOR_BROWSER_FILENAME="tor-browser-linux64-${TOR_BROWSER_VERSION}_en-US.tar.xz"
export TOR_BROWSER_DOWNLOAD_URL="https://www.torproject.org/dist/torbrowser/${TOR_BROWSER_VERSION}/${TOR_BROWSER_FILENAME}"

sudo apt-get update && \
sudo apt-get install -qq -y curl && \

rm -rf tor-browser_en-US
curl -OL "${TOR_BROWSER_DOWNLOAD_URL}"
tar -xvf ${TOR_BROWSER_FILENAME}
ln -s ~/bin/tor-browser_en-US/Browser/start-tor-browser ~/bin/tor-browser
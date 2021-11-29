#!/bin/bash

# fail if any commands fails
set -e
# debug log
set -x

#https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux&code=IIC

mkdir -p ~/bin
cd ~/bin || return
export INTELLIJ_VERSION="2021.2.3"
export INTELLIJ_DOWNLOAD_URL="https://download-cf.jetbrains.com/idea/ideaIC-${INTELLIJ_VERSION}.tar.gz"

sudo apt-get update && \
sudo apt-get install -qq -y curl unzip && \
rm -rf idea*
curl -L --silent "${INTELLIJ_DOWNLOAD_URL}" > ideaIC-${INTELLIJ_VERSION}.tar.gz
tar -xvf ideaIC-${INTELLIJ_VERSION}.tar.gz
mv idea-IC-* ideaIC-${INTELLIJ_VERSION}
ln -s ideaIC-${INTELLIJ_VERSION}/bin/idea.sh ~/bin/idea

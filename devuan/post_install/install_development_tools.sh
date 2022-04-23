#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "installing development tools..."
# intellij
mkdir -p ~/bin
cd ~/bin || return
export INTELLIJ_VERSION="2020.1"
export INTELLIJ_DOWNLOAD_URL="https://download-cf.jetbrains.com/idea/ideaIC-${INTELLIJ_VERSION}.tar.gz"

$su apt-get update && \
$su apt-get install -qq -y curl unzip && \
rm -rf idea*
curl -L --silent "${INTELLIJ_DOWNLOAD_URL}" > ideaIC-${INTELLIJ_VERSION}.tar.gz
tar -xvf ideaIC-${INTELLIJ_VERSION}.tar.gz
mv idea-IC-* ideaIC-${INTELLIJ_VERSION}
ln -s ideaIC-${INTELLIJ_VERSION}/bin/idea.sh ~/bin/idea

# vscodium
mkdir -p ~/Applications
cd ~/Applications || return
curl -O -L "$(curl -s https://api.github.com/repos/VSCodium/vscodium/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url" | head -n 1)"
echo "installing development tools... DONE"
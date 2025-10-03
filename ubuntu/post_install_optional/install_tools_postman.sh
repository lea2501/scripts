#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

mkdir -p ~/bin
cd ~/bin || return

# Remove previous file
rm -rf Postman-linux-x64.tar.gz
# Download new version
curl -o "Postman-linux-x64.tar.gz" -L "https://dl.pstmn.io/download/latest/linux64"
# Remove previous directory
rm -rf Postman
# Remove previous symlink
rm -f postman
# Extract new version
tar -xzvf Postman-linux-x64.tar.gz
# Create new symlink
ln -s Postman/app/Postman postman
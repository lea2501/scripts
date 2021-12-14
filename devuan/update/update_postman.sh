#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

mkdir -p ~/bin
cd ~/bin || return
curl -o "Postman-linux-x64.tar.gz" -L "https://dl.pstmn.io/download/latest/linux64"
tar -xzvf Postman-linux-x64.tar.gz
ln -s Postman/app/Postman postman
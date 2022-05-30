#!/bin/sh

# fail if any commands fails
set -e
# debug log
#set -x

repo="user.js"

mkdir -p ~/src
cd ~/src || return
if [ ! -d "$repo" ]; then
  git clone https://github.com/arkenfox/$repo.git
  cd "$repo" || return
else
  cd "$repo" || return
  git pull
fi

cp -v user.js ~/.mozilla/firefox/*default*/

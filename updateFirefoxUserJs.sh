#!/bin/sh

# fail if any commands fails
set -e
# debug log
#set -x

repo="https://github.com/arkenfox/user.js.git"

mkdir -p ~/src
cd ~/src || return
if [ ! -d "$repo" ]; then
  git clone $repo
  cd "$repo" || return
else
  cd "$repo" || return
  git pull
fi

cp -rv user.js ~/.mozilla/firefox/*default*/

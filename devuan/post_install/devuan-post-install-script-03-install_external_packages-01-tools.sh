#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cloneRepo() {
  mkdir -p ~/src
  cd ~/src || return
  if [ ! -d "$1" ]; then
    git clone "$2"
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

# tools
cloneRepo bash-git-prompt https://github.com/magicmonty/bash-git-prompt.git
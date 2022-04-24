#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# bash-git-prompt
application=bash-git-prompt
repository=https://github.com/magicmonty/bash-git-prompt.git
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

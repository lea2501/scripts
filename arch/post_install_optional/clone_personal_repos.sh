#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

mkdir -p ~/src
cd ~/src || return
git clone git@notabug.org:lea2501/dotfiles.git
git clone git@notabug.org:lea2501/scripts.git
git clone git@notabug.org:lea2501/guides.git
git clone git@notabug.org:lea2501/doom-random-map-sh.git
git clone git@notabug.org:lea2501/quake-random-map-sh.git

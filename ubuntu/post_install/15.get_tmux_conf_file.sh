#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cd || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.tmux.conf"

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get -y --fix-missing install stterm
$su apt-get -y --fix-missing install --no-install-recommends cwm
cd || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/devuan/.cwmrc"

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Installing packages 'minimal tools'..."
$su apt-get -y install stterm
$su apt-get -y install cwm
cd || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.cwmrc"
echo "Installing packages 'minimal tools'... DONE"
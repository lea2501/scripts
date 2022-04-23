#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Installing packages 'other browsers'..."
$su apt-get -y --fix-missing install chromium
$su apt-get -y --fix-missing install firefox-esr
$su apt-get -y --fix-missing install surf
$su apt-get -y --fix-missing install qutebrowser
echo "Installing packages 'other browsers'... DONE"

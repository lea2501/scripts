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
$su apt-get -y install chromium
$su apt-get -y install firefox-esr
$su apt-get -y install surf
echo "Installing packages 'other browsers'... DONE"
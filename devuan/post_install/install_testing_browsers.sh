#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Installing external packages 'testing browsers'..."
$su apt-get -y --fix-missing install chromium chromium-driver
$su apt-get -y --fix-missing install firefox-esr
echo "Installing external packages 'testing browsers'... DONE"
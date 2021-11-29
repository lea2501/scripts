#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing external packages 'testing browsers'..."
$su apt-get -y install chromium chromium-driver
$su apt-get -y install firefox-esr
echo "Installing external packages 'testing browsers'... DONE"
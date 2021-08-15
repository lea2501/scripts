#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# firefox
sudo apt-get -y install chromium chromium-driver
sudo apt-get -y install firefox-esr

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get update -qq
$su apt-get install -qq -y wget

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
$su apt-get update -qq
$su apt-get install -qq -y anydesk

# fix for error: "error while loading shared libraries: libpangox-1.0.so.0"
#$su apt-get install -qq -y libpangox-1.0-0
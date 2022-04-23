#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

apt-get -y --fix-missing install doas
read -rp "Enter user name: " username
echo "permit nopass ${username} as root" > /etc/doas.conf

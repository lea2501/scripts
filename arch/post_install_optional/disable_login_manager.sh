#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

read -rp "Enter used login manager name (lightdm|sddm|slim|xdm)" login_manager
$su systemctl disable "$login_manager"
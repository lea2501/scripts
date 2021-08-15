#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Disabling login manager..."
read -rp "Enter used login manager name (lightdm|sddm|slim|xdm)" login_manager
  sudo systemctl disable "$login_manager"
echo "Disabling login manager... DONE"

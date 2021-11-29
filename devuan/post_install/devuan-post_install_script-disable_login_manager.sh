#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Disabling login manager..."
read -rp "Enter used init sistem name (sysvinit|openrc|runit)" init_system
read -rp "Enter used login manager name (lightdm|sddm|slim|xdm)" login_manager
if [ "$init_system" = "sysvinit" ]; then
  sudo invoke-rc.d "$login_manager" stop
fi
if [ "$init_system" = "openrc" ]; then
  sudo rc-update del "$login_manager"
fi
if [ "$init_system" = "runit" ]; then
  sudo rm /var/service/"$login_manager"
fi
echo "Disabling login manager... DONE"
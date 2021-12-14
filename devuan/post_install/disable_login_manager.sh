#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Disabling login manager..."
read -rp "Enter used init sistem name (sysvinit|openrc|runit)" init_system
read -rp "Enter used login manager name (lightdm|sddm|slim|xdm)" login_manager
if [ "$init_system" = "sysvinit" ]; then
  $su invoke-rc.d "$login_manager" stop
fi
if [ "$init_system" = "openrc" ]; then
  $su rc-update del "$login_manager"
fi
if [ "$init_system" = "runit" ]; then
  $su rm /var/service/"$login_manager"
fi
echo "Disabling login manager... DONE"
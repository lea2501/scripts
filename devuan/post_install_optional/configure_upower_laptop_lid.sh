#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su sed -i 's/IgnoreLid=false/IgnoreLid=true/g' /etc/UPower/UPower.conf

read -rp "Enter used init sistem name (sysvinit|openrc|runit)" init_system
if [ "$init_system" = "sysvinit" ]; then
  #TODO sudo update-rc.d upower restart
fi
if [ "$init_system" = "openrc" ]; then
  #TODO $su rc-update del "$login_manager"
fi
if [ "$init_system" = "runit" ]; then
  #TODO $su rm /var/service/"$login_manager"
fi

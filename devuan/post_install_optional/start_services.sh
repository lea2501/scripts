#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

#  read -rp "Enter used init sistem name (sysvinit|openrc|runit)" init_system

#  # start docker
#  if [ "$init_system" = "sysvinit" ]; then
#    $su /etc/init.d/docker start
#  fi
#  if [ "$init_system" = "openrc" ]; then
#    $su rc-update add docker default
#    $su rc-service docker start
#  fi
#  if [ "$init_system" = "runit" ]; then
#    $su sv up docker
#  fi

# setup docker
$su groupadd docker || true
$su gpasswd -a $USER docker || true

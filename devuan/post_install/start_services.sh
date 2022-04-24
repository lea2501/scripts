#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
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

## start NTP
#if [ "$init_system" = "sysvinit" ]; then
#  $su /etc/init.d/ntp start
#fi
#if [ "$init_system" = "openrc" ]; then
#  rc-update add ntp default
#  rc-service ntp start
#fi
#if [ "$init_system" = "runit" ]; then
#  #TODO
#  #$su rm /var/service/$login_manager
#fi

## start SSH daemon
#if [ "$init_system" = "sysvinit" ]; then
#  $su /etc/init.d/sshd start
#fi
#if [ "$init_system" = "openrc" ]; then
#  rc-update add sshd default
#  rc-service sshd start
#fi
#if [ "$init_system" = "runit" ]; then
#  #TODO
#  #$su rm /var/service/$login_manager
#fi

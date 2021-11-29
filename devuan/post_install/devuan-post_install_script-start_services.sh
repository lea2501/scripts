#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x


#  read -rp "Enter used init sistem name (sysvinit|openrc|runit)" init_system

#  # start docker
#  echo "Enabling and starting docker service..."
#  if [ "$init_system" = "sysvinit" ]; then
#    sudo /etc/init.d/docker start
#  fi
#  if [ "$init_system" = "openrc" ]; then
#    sudo rc-update add docker default
#    sudo rc-service docker start
#  fi
#  if [ "$init_system" = "runit" ]; then
#    sudo sv up docker
#  fi
#  echo "Enabling and starting docker service... DONE"

# setup docker
echo "Setup docker for normal user usage..."
sudo groupadd docker || true
sudo gpasswd -a $USER docker || true
echo "Setup docker for normal user usage... DONE"

## start NTP
#echo "Enabling and starting ntp service..."
#if [ "$init_system" = "sysvinit" ]; then
#  sudo /etc/init.d/ntp start
#fi
#if [ "$init_system" = "openrc" ]; then
#  rc-update add ntp default
#  rc-service ntp start
#fi
#if [ "$init_system" = "runit" ]; then
#  #TODO
#  #sudo rm /var/service/$login_manager
#fi
#echo "Enabling and starting ntp service... DONE"

## start SSH daemon
#echo "Enabling and starting ntp service..."
#if [ "$init_system" = "sysvinit" ]; then
#  sudo /etc/init.d/sshd start
#fi
#if [ "$init_system" = "openrc" ]; then
#  rc-update add sshd default
#  rc-service sshd start
#fi
#if [ "$init_system" = "runit" ]; then
#  #TODO
#  #sudo rm /var/service/$login_manager
#fi
#echo "Enabling and starting ntp service... DONE"
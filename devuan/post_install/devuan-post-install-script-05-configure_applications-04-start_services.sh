#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

read -rp "Enter used init sistem name (systemd|sysvinit|openrc|runit)" init_system

# start docker
echo "Enabling and starting docker service..."
if [ "$init_system" = "systemd" ]; then
  sudo systemctl enable docker
  sudo systemctl start docker
fi
if [ "$init_system" = "sysvinit" ]; then
  sudo invoke-rc.d docker start
fi
if [ "$init_system" = "openrc" ]; then
  rc-update add docker default
  rc-service docker start
fi
if [ "$init_system" = "runit" ]; then
  #TODO
  #sudo rm /var/service/$login_manager
fi
echo "Enabling and starting docker service... DONE"

# setup docker
echo "Setup docker for normal user usage..."
sudo groupadd docker || true
sudo gpasswd -a $USER docker || true
echo "Setup docker for normal user usage... DONE"

# start NTP
echo "Enabling and starting ntp service..."
sudo systemctl enable ntpdate.service
sudo systemctl start ntpdate.service
echo "Enabling and starting ntp service... DONE"

# start SSH daemon
echo "Enabling and starting ntp service..."
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
echo "Enabling and starting ntp service... DONE"

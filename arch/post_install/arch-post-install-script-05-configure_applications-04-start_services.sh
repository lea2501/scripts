#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# start docker
echo "Enabling and starting docker service..."
sudo systemctl enable docker
sudo systemctl start docker
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
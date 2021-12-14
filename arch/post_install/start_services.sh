#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

# start docker
echo "Enabling and starting docker service..."
$su systemctl enable docker
$su systemctl start docker
echo "Enabling and starting docker service... DONE"

# setup docker
echo "Setup docker for normal user usage..."
$su groupadd docker || true
$su gpasswd -a $USER docker || true
echo "Setup docker for normal user usage... DONE"

# start NTP
echo "Enabling and starting ntp service..."
$su systemctl enable ntpdate.service
$su systemctl start ntpdate.service
echo "Enabling and starting ntp service... DONE"

# start SSH daemon
echo "Enabling and starting ntp service..."
$su systemctl enable sshd.service
$su systemctl start sshd.service
echo "Enabling and starting ntp service... DONE"
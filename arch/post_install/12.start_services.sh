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
$su systemctl enable docker
$su systemctl start docker

# setup docker
$su groupadd docker || true
$su gpasswd -a $USER docker || true

# start NTP
$su systemctl enable ntpdate.service
$su systemctl start ntpdate.service

# start SSH daemon
$su systemctl enable sshd.service
$su systemctl start sshd.service

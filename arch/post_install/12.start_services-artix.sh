#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

# start docker
$su dinitctl enable docker
$su dinitctl start docker

# setup docker
$su groupadd docker || true
$su gpasswd -a $USER docker || true

# start NTP
$su dinitctl enable ntpdate.service
$su dinitctl start ntpdate.service

# start SSH daemon
$su dinitctl enable sshd.service
$su dinitctl start sshd.service

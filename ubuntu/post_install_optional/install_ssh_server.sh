#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt install openssh-client openssh-server

$su cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
$su chmod a-w /etc/ssh/sshd_config.original

$su vim /etc/ssh/sshd_config

# start ssh server
$su sshd -t -f /etc/ssh/sshd_config

# restart
sudo systemctl restart sshd.service
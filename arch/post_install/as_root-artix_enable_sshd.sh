#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

pacman -S openssh openssh-openrc
rc-update add sshd default
rc-service sshd start

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i '' 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i '' 's/#PermitUserEnvironment no/PermitUserEnvironment yes/g' /etc/ssh/sshd_config

read -rp "Enter user name: " username
echo "AllowUsers ${username}" > /etc/ssh/sshd_config

rc-service sshd restart

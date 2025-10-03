#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

#pacman -S openssh openssh-openrc
#rc-update add sshd default
#rc-service sshd start

pacman -S openssh openssh-dinit
dinitctl enable sshd
dinitctl start sshd

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

cat /etc/ssh/sshd_config | sed -e "s/#PermitRootLogin yes/PermitRootLogin no/g" | tee /etc/ssh/sshd_config.new
cat /etc/ssh/sshd_config | sed -e "s/#PermitUserEnvironment no/PermitUserEnvironment yes/g" | tee /etc/ssh/sshd_config.new
mv /etc/ssh/sshd_config.new /etc/ssh/sshd_config

read -rp "Enter user name: " username
echo "AllowUsers ${username}" >> /etc/ssh/sshd_config

#rc-service sshd restart
dinitctl restart sshd

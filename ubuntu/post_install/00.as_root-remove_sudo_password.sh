#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

apt-get -y --fix-missing install sudo
read -rp "Enter user name: " username
echo "${username} ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

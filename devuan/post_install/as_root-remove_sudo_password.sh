#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

apt install sudo
read -rp "Enter user name: " username
echo "${username} ALL=(ALL) NOPASSWD: ALL" | EDITOR='tee -a' visudo
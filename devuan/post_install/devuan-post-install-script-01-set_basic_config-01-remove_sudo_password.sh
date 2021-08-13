#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Removing asking for sudo password for user..."
username=$(echo "$USER")
echo "Using 'su -' command to gain root privileges..."
su -
echo "Using 'su -' command to gain root privileges... DONE"
echo "${username} ALL=(ALL) NOPASSWD: ALL" | EDITOR='tee -a' visudo
echo "Removing asking for sudo password for user... DONE"

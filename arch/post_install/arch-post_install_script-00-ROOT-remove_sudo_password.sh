#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Removing asking for sudo password for user..."
read -rp "Enter user name: " username
echo "${username} ALL=(ALL) NOPASSWD: ALL" | EDITOR='tee -a' visudo
echo "Removing asking for sudo password for user... DONE"

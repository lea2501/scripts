#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

# shellcheck disable=SC2116
username=$(echo "$USER")

echo "Removing asking for sudo password for user..."
echo "${username} ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
echo "Removing asking for sudo password for user... DONE"

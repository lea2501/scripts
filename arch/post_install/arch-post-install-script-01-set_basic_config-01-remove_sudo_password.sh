#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Removing asking for sudo password for user..."
username=$(echo "$USER")
echo "${username} ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
echo "Removing asking for sudo password for user... DONE"

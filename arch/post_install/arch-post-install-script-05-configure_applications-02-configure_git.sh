#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Configuring Git options..."
read -rp "Enter Git user email: " gitUserEmail
git config --global user.email "$gitUserEmail"
read -rp "Enter Git user name: " gitUserName
git config --global user.name "$gitUserName"
git config --global pull.rebase false
echo "Configuring Git options... DONE"
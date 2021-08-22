#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Removing asking for sudo password for user..."
username=$(echo "$USER")
echo "To get sudo working execute following commands:"
echo "$ su -"
echo "  (Enter root password)"
echo "# echo \"${username} ALL=(ALL) NOPASSWD: ALL\" | EDITOR='tee -a' visudo"
echo "# exit"
echo "Removing asking for sudo password for user... DONE"

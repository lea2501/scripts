#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

read -rp "Remove asking for sudo password?: (y|n)" removeAskingSudoPassword

# Setup system
if [ "$removeAskingSudoPassword" = "y" ]; then
  echo "Removing asking for sudo password for user..."
  echo "Open another terminal emulator and run command:"
  echo "  $ sudo visudo"
  echo "And change line:"
  echo "  %admin ALL=(ALL) ALL"
  echo "To"
  echo "  %admin ALL=(ALL) NOPASSWD: ALL"
  read -p "Press enter to continue"
  echo "Removing asking for sudo password for user... DONE"
fi
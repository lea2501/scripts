#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Open another terminal emulator and run command:"
echo "  $ sudo visudo"
echo "And change line:"
echo "  %admin ALL=(ALL) ALL"
echo "To"
echo "  %admin ALL=(ALL) NOPASSWD: ALL"
read -p "Press enter to continue"

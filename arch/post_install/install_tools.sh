#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing packages 'tools'..."
# tools
paru -S bash-git-prompt tsmuxer-git vim-gnupg scalpel-git guymager
echo "Installing packages 'tools'... DONE"
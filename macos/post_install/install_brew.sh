#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" </dev/null
brew tap homebrew/cask
echo "Installing brew... DONE"
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing packages 'testing browsers'..."
paru -S firefox google-chrome chromedriver 
echo "Installing packages 'testing browsers'... DONE"

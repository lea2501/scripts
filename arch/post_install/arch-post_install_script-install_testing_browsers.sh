#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing packages 'testing browsers'..."
paru -S chromium firefox-esr-bin surf amfora bombadillo lagrange
echo "Installing packages 'testing browsers'... DONE"
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Installing packages 'other browsers'..."
#paru -S chromium firefox-esr-bin surf amfora bombadillo lagrange
paru -S chromium firefox-esr-bin surf lagrange dooble-bin badwolf qutebrowser
echo "Installing packages 'other browsers'... DONE"

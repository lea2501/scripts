#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# browsers
echo \
  'chromium
firefox-esr-bin
dillo
surf
amfora
bombadillo
lagrange' >>packages.txt

paru -S $(cat packages.txt)
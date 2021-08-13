#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Setting java default version..."
sudo update-alternatives --config java
java -version
echo "Setting java default version... DONE"
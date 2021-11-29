#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Updating clamav virus definition database..."
sudo freshclam
echo "Updating clamav virus definition database... Done"
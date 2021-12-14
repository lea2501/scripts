#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Updating clamav virus definition database..."
$su freshclam
echo "Updating clamav virus definition database... Done"
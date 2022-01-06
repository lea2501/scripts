#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Setting java default version..."
$su archlinux-java set java-17-openjdk
echo "Setting java default version... DONE"
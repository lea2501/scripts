#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Setting java default version..."
$su archlinux-java set java-11-openjdk
echo "Setting java default version... DONE"
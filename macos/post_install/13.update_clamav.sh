#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cp /usr/local/etc/clamav/freshclam.conf.sample /usr/local/etc/clamav/freshclam.conf
sed -i '' 's/Example/#Example/g' /usr/local/etc/clamav/freshclam.conf
freshclam

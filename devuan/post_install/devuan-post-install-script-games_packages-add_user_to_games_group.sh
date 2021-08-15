#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

username=$(echo "$USER")
gpasswd -a "${username}" games
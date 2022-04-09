#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# configure slackpkgmirror
cp /etc/slackpkg/mirrors /etc/slackpkg/mirrors.bak
cat /etc/slackpkg/mirrors | sed -e "s/# http:\/\/mirror.csclub.uwaterloo.ca/ http:\/\/mirror.csclub.uwaterloo.ca/" | tee /etc/slackpkg/mirrors.edited
mv /etc/slackpkg/mirrors.edited /etc/slackpkg/mirrors

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

{
  echo ""
  echo "deb     http://deb.devuan.org/merged chimaera-backports main contrib non-free"
  echo "deb-src http://deb.devuan.org/merged chimaera-backports main contrib non-free"
} >>/etc/apt/sources.list

apt update
apt full-upgrade -y

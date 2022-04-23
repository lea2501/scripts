#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

read -rp "Enter password: " password
nmcli device wifi connect 8C:FD:DE:94:90:3F password MGMKNDWMZJH${password}
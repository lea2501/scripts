#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

read -rp "Enter used login manager name (lightdm|sddm|slim|xdm)" login_manager
$su systemctl disable "$login_manager"
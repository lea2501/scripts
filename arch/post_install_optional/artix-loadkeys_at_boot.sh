#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

# show available keymaps
find /usr/share/kbd/keymaps/ -type f | grep la

$su sed -i 's/keymap="us"/keymap="es"/g' /etc/conf.d/keymaps
$su sed -i 's/KEYMAP=us/KEYMAP=es/g' /etc/vconsole.conf
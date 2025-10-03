#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

cd || return

echo ""
echo -e "\033[33;5m If using laptop, unplug any external displays if connected... \033[0m"
echo ""
read -rp "Press enter when finish..."

  {
    echo "Section \"Device\""
    echo "    Identifier \"AMD\""
    echo "    Driver \"amdgpu\""
    echo "    Option \"TearFree\" \"true\""
    echo "EndSection"
  } | $su tee -a /etc/X11/xorg.conf.d/20-amdgpu.conf

output=$(xrandr | grep " connected " | awk '{print $1;}')

echo "To enable immediately just type: '$ xrandr --output $output --set TearFree on'"

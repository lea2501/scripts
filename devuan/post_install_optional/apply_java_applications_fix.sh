#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su echo "export _JAVA_AWT_WM_NONREPARENTING=1" | $su tee -a /etc/profile.d/jre.sh
#echo "export AWT_TOOLKIT=MToolkit" >> ~/.xinitrc
#echo "wmname compiz"

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Apply fix for misbehaving java applications..."
$su echo "export _JAVA_AWT_WM_NONREPARENTING=1" | sudo tee -a /etc/profile.d/jre.sh
#echo "export AWT_TOOLKIT=MToolkit" >> ~/.xinitrc
#echo "wmname compiz"
echo "Apply fix for misbehaving java applications... DONE"
#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

sudo echo "export _JAVA_AWT_WM_NONREPARENTING=1" | $su tee -a /etc/profile.d/jre.sh
#echo "export AWT_TOOLKIT=MToolkit" >> ~/.xinitrc
#echo "wmname compiz"

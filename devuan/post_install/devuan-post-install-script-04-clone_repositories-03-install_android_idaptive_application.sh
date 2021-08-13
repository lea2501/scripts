#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Connect to anyConnect VPN"
echo "  In a smartphone, search and install 'Idaptive' application from Play Store"
echo "    https://play.google.com/store/apps/details?id=com.centrify.mdm.samsung"
echo "  If using a smartphone without google play or google services do:"
echo "    1) Download and install 'F-Droid' from https://f-droid.org/F-Droid.apk"
echo "    2) Install 'Aurora Store' from F-Droid"
echo "    3) Install 'Idaptive' from Aurora Store"
echo ""
echo "Idaptive mobile application steps:"
echo "  1) Open 'Idaptive' mobile application"
echo "  2) Login using \"uXXXXXX@telecom\" (don't put 'uXXXXXX@teco.com.ar') and \"LAN password\"."
echo "  3) Don't wait for apps to load (It won't). Go to menu and select \"Mobile Authenticator\"."
echo "  4) Use temporary token to connect to VPN."
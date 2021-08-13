#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Connecting to Cisco AnyConnect VPN..."
read -rp "Enter Cisco AnyConnect VPN username (uXXXXXX): " openconnectUsername
echo "Open a new terminal and do the following..."
echo "    $ openconnect_anyconnect"
echo "    or..."
echo "    $ sudo /usr/bin/openconnect -u ${openconnectUsername} vpn-ssl.telecom.com.ar"
echo "  When asking for password enter your 'LAN password'"
echo "  When asking for password again, enter the Idaptive temporary token password"
echo ""
echo -e "\033[33;5m PLEASE NOTE THAT BOTH PASSWORD PROMPTS LOOK THE SAME! \033[0m"
echo ""
read -rp "Press enter to continue"
echo "Connecting to Cisco AnyConnect VPN... DONE"
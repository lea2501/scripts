#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

doas rfkill unblock wifi
#doas ip link set wlan0 up
connmanctl scan wifi && wait $!
connmanctl services && wait $!
connmanctl connect wifi_085bd658a075_47616c6178792041333244313644_managed_psk

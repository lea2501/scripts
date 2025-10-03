#!/bin/sh

ip_address=$($HOME/src/scripts/checkIpAddress.sh public)
if [ "$ip_address" == "n/a" ]; then
    doas ifconfig urtwn0 nwid Telecentro-903a wpakey MGMKNDWMZJHZ
fi

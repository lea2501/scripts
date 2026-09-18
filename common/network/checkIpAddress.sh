#!/bin/sh

if [ "$1" = "public" ]; then
    ip=$(curl --silent --connect-timeout 1 ifconfig.me)
elif [ "$1" = "private" ]; then
    ip=$(ifconfig -a | grep "inet 192.168." | awk '{print $2}' | head -1)
fi
if [ -n "$ip" ]; then
    echo "$ip"
else
    echo "n/a"
fi

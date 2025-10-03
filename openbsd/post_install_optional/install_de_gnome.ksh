#!/bin/ksh

doas pkg_add gnome
doas rcctl disable xenodm
echo "Disable xenodm > OK"
doas rcctl enable multicast messagebus avahi_daemon gdm
echo "Enable 'multicast messagebus avahi_daemon gdm' > OK"
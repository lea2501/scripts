#!/bin/sh

ip_address=$("$HOME/src/scripts/checkIpAddress.sh" public)
if [ "$ip_address" = "n/a" ]; then
    printf 'SSID de la red Wi-Fi: '
    read -r wifi_network
    printf 'Contraseña Wi-Fi: '
    trap 'stty echo' EXIT HUP INT TERM
    stty -echo
    read -r wifi_password
    stty echo
    trap - EXIT HUP INT TERM
    printf '\n'

    if [ -z "$wifi_network" ] || [ -z "$wifi_password" ]; then
        echo "ERROR: la red y la contraseña son obligatorias." >&2
        exit 1
    fi

    doas ifconfig urtwn0 nwid "$wifi_network" wpakey "$wifi_password"
    unset wifi_password
fi

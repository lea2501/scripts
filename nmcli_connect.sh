#!/bin/bash

# fail if any commands fails
set -e
# La contraseña se pide sin eco para no dejarla en el script ni en el historial.
read -r -p "BSSID o SSID de la red Wi-Fi: " wifi_network
read -r -s -p "Contraseña Wi-Fi: " wifi_password
echo

if [ -z "$wifi_network" ] || [ -z "$wifi_password" ]; then
  echo "ERROR: la red y la contraseña son obligatorias." >&2
  exit 1
fi

nmcli device wifi connect "$wifi_network" password "$wifi_password"
unset wifi_password

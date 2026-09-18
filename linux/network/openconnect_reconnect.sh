#!/bin/bash

# fail if any commands fails
set -e
vpn_server="boromir.fibertel.com.ar"
vpn_servercert=""

read -r -p "Usuario VPN: " vpn_username
read -r -s -p "Contraseña VPN: " vpn_password
echo

if [ -z "$vpn_username" ] || [ -z "$vpn_password" ]; then
  echo "ERROR: el usuario y la contraseña son obligatorios." >&2
  exit 1
fi

# try connect
while true; do
  retry_time=$(($(date +%s) + 30))
  sudo openconnect \
    -u "$vpn_username" "$vpn_server" --non-inter --passwd-on-stdin <<<"$vpn_password"

  #cat ~/.ocvpn_secret | sudo /usr/bin/openconnect \
  #--juniper $vpn_server \
  #--servercert sha256:$vpn_servercert \
  #--user=$vpn_username \
  #--passwd-on-stdin
  current_time=$(date +%s)
  if [ $current_time -lt retry_time ]; then
    sleep $(($retry_time - $current_time))
  fi
done

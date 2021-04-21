#!/bin/bash

# fail if any commands fails
set -e
# debug log
set -x

vpn_server="boromir.fibertel.com.ar"
vpn_username="username"
vpn_password="password"
vpn_servercert=""
# try connect
while true; do
  retry_time=$(($(date +%s) + 30))
  sudo openconnect \
    -u $vpn_username $vpn_server --non-inter --passwd-on-stdin <<<"$vpn_password"

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

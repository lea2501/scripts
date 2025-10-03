#!/bin/sh

if [ "$1" = "" ]; then
  echo "USAGE: $0 [INTERFACE]"
  exit 0
fi

get_date (){
	echo "$(date '+%Y%m%d-%H%M%S')"
}

check_ip (){
  ip=$(curl --silent --connect-timeout 1 ifconfig.me)
  if [ "$ip" = "" ]; then
    last_connection_lost_date=$(cat /tmp/connection_lost_date)
    date +"%s" > /tmp/connection_lost_date
    current_connection_lost_date=$(cat /tmp/connection_lost_date)
    connection_time=$((current_connection_lost_date-last_connection_lost_date))
    doas sh /etc/netstart $1
    sleep 10
    echo "ERROR: $(get_date) - $0 - Connection reset after $connection_time seconds"
  fi
}

date +"%s" > /tmp/connection_lost_date

while true
do
  check_ip
  sleep 10
done

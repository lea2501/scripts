#!/bin/sh

param_iwad="$1"
param_pwad="$2"
param_game_dir="$HOME/games/doom"
config_iwad=$(find /home/lea/games/doom/maps/iwads/${param_iwad}.wad)
echo "INFO: iwad file: $config_iwad"
pwadfilename=$(echo ${param_pwad} | awk -F/ '{print $10}')
pwadfilename=$(basename -- "${pwadfilename%.*}")
echo "PWAD name: $pwadfilename"

installed_bin=$(whereis gzdoom)
compiled_bin="$HOME/src/gzdoom/build/gzdoom"
set -x
cd /tmp
export DOOMWADDIR=/usr/local/share/games/doom/

$(if [ ! -z $installed_bin ]; then echo "gzdoom"; else if [ -f "$compiled_bin" ]; then echo "$compiled_bin"; fi; fi) \
-iwad $config_iwad -file $param_pwad -norun -hashfiles > /dev/null || true

if [ "$param_iwad" = "doom2" ]; then
  pwadmap=$(cat fileinfo.txt | grep $pwadfilename | grep -e " MAP" -e " maps/" | awk '{print $4}' | sed -e "s/^MAP//" -e 's/,//g' | shuf -n 1)
  if [ -z $pwadmap ]; then
	  pwadmap=$(cat fileinfo.txt | grep $pwadfilename | grep " maps/" | awk '{print $4}' | sed -e "s/^maps\/map//" -e 's/.wad,//g' | shuf -n 1)
  fi
  echo "PWAD map number: $pwadmap"

  mapnumbercheck=$(echo "$pwadmap" | awk '$0 ~/[^0-9]/ { print "NOT_NUMBER" }')
elif [[ $param_iwad == "doom" ]]; then
  pwadmap=$(cat fileinfo.txt | grep $pwadfilename | grep -e " E[1-5]M" | awk '{print $4}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
  echo "PWAD map number: $pwadmap"
elif [[ $param_iwad == "heretic" ]]; then
  pwadmap=$(cat fileinfo.txt | grep $pwadfilename | grep -e " E[1-5]M" | awk '{print $4}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
  echo "PWAD map number: $pwadmap"
elif [[ $param_iwad == "hexen" ]]; then
  pwadmap=$(cat fileinfo.txt | grep $pwadfilename | grep -e " E[1-5]M" | awk '{print $4}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
  echo "PWAD map number: $pwadmap"
fi

set +x

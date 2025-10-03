#!/bin/sh

param_iwad="$1"
param_pwad="$2"
param_game_dir="$HOME/games/doom"
config_iwad=$(find $HOME/games/doom/maps/iwads/${param_iwad}.wad)
#echo "INFO: iwad file: $config_iwad"
pwadfilename=$(echo ${param_pwad} | awk -F/ '{print $10}')
pwadfilename=$(basename -- "${pwadfilename%.*}")
#echo "PWAD name: $pwadfilename"

installed_bin=$(whereis wadxtract)
compiled_bin="$HOME/src/wadtools/build/wadxtract"
cd /tmp
rm -rf wadxtract
mkdir -p wadxtract
cd wadxtract

#$(if [ ! -z $installed_bin ]; then echo "wadxtract"; else if [ -f "$compiled_bin" ]; then echo "$compiled_bin"; fi; fi) \
$compiled_bin \
$param_pwad . > wadxtract_output

if [ "$param_iwad" = "doom2" ] || [ "$param_iwad" = "plutonia" ] || [ "$param_iwad" = "tnt" ]; then
  pwadmap=$(cat wadxtract_output | grep -e "Extracting MAP" -e " maps/" | awk '{print $2}' | sed -e "s/^MAP//" -e 's/,//g' | shuf -n 1)
elif [ "$param_iwad" = "doom" ]; then
  pwadmap=$(cat wadxtract_output | grep -e "Extracting E[1-5]M" | awk '{print $2}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
elif [ "$param_iwad" = "heretic" ]; then
  pwadmap=$(cat wadxtract_output | grep -e "Extracting E[1-5]M" | awk '{print $2}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
elif [ "$param_iwad" = "hexen" ]; then
  pwadmap=$(cat wadxtract_output | grep -e "Extracting E[1-5]M" | awk '{print $2}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
fi

echo "$pwadmap"

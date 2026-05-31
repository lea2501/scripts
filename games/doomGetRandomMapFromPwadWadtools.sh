#!/bin/sh

param_iwad="$1"
param_pwad="$2"
param_game_dir="$HOME/games/doom"
config_iwad=$(find "$HOME"/games/doom/maps/iwads/"${param_iwad}".wad 2>/dev/null)
pwadfilename=$(basename -- "${param_pwad%.*}")

compiled_bin="$HOME/src/wadtools/build/wadxtract"
cd /tmp
rm -rf wadxtract
mkdir -p wadxtract
cd wadxtract

"$compiled_bin" "$param_pwad" . > wadxtract_output

if [ "$param_iwad" = "doom2" ] || [ "$param_iwad" = "plutonia" ] || [ "$param_iwad" = "tnt" ]; then
  pwadmap=$(grep -e "Extracting MAP" -e " maps/" wadxtract_output | awk '{print $2}' | sed -e "s/^MAP//" -e 's/,//g' | shuf -n 1)
elif [ "$param_iwad" = "doom" ]; then
  pwadmap=$(grep -e "Extracting E[1-5]M" wadxtract_output | awk '{print $2}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
elif [ "$param_iwad" = "heretic" ]; then
  pwadmap=$(grep -e "Extracting E[1-5]M" wadxtract_output | awk '{print $2}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
elif [ "$param_iwad" = "hexen" ]; then
  pwadmap=$(grep -e "Extracting E[1-5]M" wadxtract_output | awk '{print $2}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
fi

echo "$pwadmap"

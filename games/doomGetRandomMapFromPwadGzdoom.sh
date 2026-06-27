#!/bin/sh

param_iwad="$1"
param_pwad="$2"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common_paths.sh"
config_iwad=$(iwad_path "$param_iwad")
echo "INFO: iwad file: $config_iwad"
pwadfilename=$(basename -- "${param_pwad%.*}")
echo "PWAD name: $pwadfilename"

compiled_bin="$HOME/src/gzdoom/build/gzdoom"
bin=$(command -v gzdoom 2>/dev/null || echo "$compiled_bin")

cd /tmp
export DOOMWADDIR=/usr/local/share/games/doom/

"$bin" -iwad "$config_iwad" -file "$param_pwad" -norun -hashfiles > /dev/null || true

case "$param_iwad" in
  doom2)
    pwadmap=$(grep "$pwadfilename" fileinfo.txt | grep -e " MAP" -e " maps/" | awk '{print $4}' | sed -e "s/^MAP//" -e 's/,//g' | shuf -n 1)
    if [ -z "$pwadmap" ]; then
      pwadmap=$(grep "$pwadfilename" fileinfo.txt | grep " maps/" | awk '{print $4}' | sed -e "s/^maps\/map//" -e 's/.wad,//g' | shuf -n 1)
    fi
    echo "PWAD map number: $pwadmap"
    ;;
  doom|heretic|hexen)
    pwadmap=$(grep "$pwadfilename" fileinfo.txt | grep -e " E[1-5]M" | awk '{print $4}' | shuf -n 1 | sed -r 's/[EM]+/ /g' | sed -e "s/^0//" -e 's/,//g')
    echo "PWAD map number: $pwadmap"
    ;;
esac

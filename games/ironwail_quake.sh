#!/bin/sh
set -x

config_game_dir=~/games/quake
config_script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mapfile=$(find $config_game_dir/*/{maps/*.bsp,pak0.pak} -type f | shuf -n 1)

installed_bin=$(which qpakman 2>/dev/null || echo false)
compiled_bin="$HOME/src/qpakman/qpakman"
qpakman_command=$(if [ ! $installed_bin = "false" ]; then echo "qpakman"; else if [ -f "$compiled_bin" ]; then echo "$compiled_bin"; fi; fi) \

get_random_map() {
	if [[ "$mapfile" == *"pak"* ]]; then
		# Get map directory name
		mapdir=$(dirname $mapfile)
		mapdir=$(echo ${mapdir} | awk -F/ '{print $(NF)}')
		# Get map pak file map name
		pakfile=$mapfile
		mapfile=$(${qpakman_command} -l "$pakfile" | grep 'maps/' | grep '.bsp' | awk '{ print $5 }' | shuf -n 1)
	else
		# Get map directory name
		mapdir=$(dirname "$mapfile")
		mapdir=$(echo ${mapdir} | awk -F/ '{print $(NF-1)}')
	fi
}

get_random_map
while [ -z $mapdir ]
do
    unset mapdir
    get_random_map
done

echo "INFO: $0 - Map directory $mapdir"

# get map name
mapname=$(basename -- "${mapfile%.*}")
echo "INFO: $0 - Map name $mapname"

# run
installed_bin=$(which ironwail 2>/dev/null || echo false)
compiled_bin="$HOME/src/ironwail/Quake/ironwail"
set -x
$(if [ ! $installed_bin = "false" ]; then echo "ironwail"; else if [ -f "$compiled_bin" ]; then echo "$compiled_bin"; fi; fi) \
-current -basedir $config_game_dir -heapsize 524288 -zone 4096 -game $mapdir +map $mapname +skill 1 -fitz \
+r_particles 2 +r_lerpmodels 1 +r_lerpmove 1 +r_viewmodel_quake 1 +r_scale 1 +scr_ofsx -2.8 +scr_sbaralpha 1 +v_gunkick 2 +gamma 1.2 +contrast 1.5 +fov 85 +fog 0.02 +scr_showfps 1 \
> /tmp/ironwail.log
set +x

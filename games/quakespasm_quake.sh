#!/bin/sh

game_dir="$HOME/games/quake"
map_file=$(find "$game_dir"/*/maps/*.bsp \
  $game_dir/*/maps/*.pak \
  $game_dir/*/*.bsp \
  $game_dir/*/*.pak -ls | sort -rn | awk '{print $11}')

get_random_map() {
	if [ "$map_file" == *"pak"* ]; then
		# Get map directory name
		mapdir=$(dirname $mapfile)
		mapdir=$(echo ${mapdir} | awk -F/ '{print $(NF)}')
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
installed_bin=$(which quakespasm 2>/dev/null || echo false)
compiled_bin="$HOME/src/quakespasm-quakespasm/Quake/quakespasm"
set -x
$(if [ ! $installed_bin = "false" ]; then echo "quakespasm"; else if [ -f "$compiled_bin" ]; then echo "$compiled_bin"; fi; fi) \
-current -basedir $config_game_dir -heapsize 524288 -zone 4096 -game $mapdir +map $mapname +skill 1 -fitz \
+r_particles 2 +r_lerpmodels 1 +r_lerpmove 1 +r_viewmodel_quake 1 +r_scale 1 +scr_ofsx -2.8 +scr_sbaralpha 1 +v_gunkick 2 +gamma 1.2 +contrast 1.5 +fov 85 +fog 0.02 +scr_showfps 1 \
> /tmp/quakespasm.log
set +x

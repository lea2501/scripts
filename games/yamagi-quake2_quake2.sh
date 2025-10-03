#!/bin/sh

config_game_dir=~/games/quake2
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
system_name=$(uname)
if [ $system_name="OpenBSD" ]; then
    installed_bin=$(which quake2 2>/dev/null || echo false)
    installed_bin_name=quake2
else
    installed_bin=$(which yamagi-quake2 2>/dev/null || echo false)
    installed_bin_name=yamagi-quake2
fi
compiled_bin="$HOME/src/yquake2/release/baseq2"
set -x
$(if [ ! $installed_bin = "false" ]; then echo $installed_bin_name; else if [ -f "$compiled_bin" ]; then echo "$compiled_bin"; fi; fi) \
  +seta r_customheight 1920 \
  +seta r_customwidth 1080 \
  +seta vid_fullscreen 1 \
  +seta r_mode -1 \
  +set vid_renderer gl3 \
  +set gl3_particle_square 1 \
  +set gl3_colorlight 1 \
  +set gl_texturemode GL_NEAREST \
  +set vid_restart 1 \
  +set al_driver libopenal.so.4.2 \
  +set ogg_enable 1 \
  -datadir $config_game_dir \
  +game $mapdir +skill 0 \
  +map $mapname \
  +set cl_showfps 2 \
  +seta com_allowconsole 1 \
  > /tmp/quake2.log
set +x

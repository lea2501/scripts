#!/bin/sh
echo "Usage: $0 [map]"

#find ~/games/quake/*/{maps/*.bsp,pak0.pak} -type f

mapdir=$(dirname $1)
mapdir=$(awk -F/ '{print $(NF-1)}' <<< "${mapdir}")
mapname=$(basename -- "$1" ".bsp")

quakespasm -width 1920 -height 1080 -fullscreen -basedir ~/games/quake/ -heapsize 256000 -zone 4096 -game $mapdir +map $mapname +skill 1 +mlook +r_particles 2 +r_lerpmodels 0 +r_lerpmove 0 +r_viewmodel_quake 1 +r_scale 3 +scr_ofsx -2.8 +scr_sbaralpha 1 +v_gunkick 2 +gamma 1.2 +contrast 1.5 +fov 85 +fog 0.02 -fitz

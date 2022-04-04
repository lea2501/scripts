#!/bin/sh
if [[ -z $1 ]] || [[ "$1" == "-h" ]]; then
  echo "Usage:"
  echo "  $ $(basename $0) [map]"
  echo "  $ export retro=0 && $(basename $0) [map]"
  echo "  $ export retro=1 && $(basename $0) [map]"
  echo ""
  echo "To list all available game and maps:"
  echo "  $ $(basename $0) --list|-l"
  echo ""
  exit
fi
if [[ "$1" == "--list" ]] || [[ "$1" == "-l" ]]; then
  find ~/games/quake/*/{maps/*.bsp,pak0.pak} -type f
  echo ""
  exit
fi

# set default options
if [[ -z $retro ]] || [[ "$retro" == "0" ]]; then
      export r_lerpmodels=1
      export r_lerpmove=1
      export r_scale=1
  elif [[ "$retro" == "1" ]]; then
      export r_lerpmodels=0
      export r_lerpmove=0
      export r_scale=3
else
    echo "invalid retro variable options, valid ones are 0 or 1, exiting"
fi

mapdir=$(dirname $1)
mapdir=$(awk -F/ '{print $(NF-1)}' <<< "${mapdir}")
mapname=$(basename -- "$1" ".bsp")

quakespasm -width 1920 -height 1080 -fullscreen -basedir ~/games/quake/ -heapsize 256000 -zone 4096 -game $mapdir +map $mapname +skill 1 +mlook +r_particles 2 +r_lerpmodels $r_lerpmodels +r_lerpmove $r_lerpmove +r_viewmodel_quake 1 +r_scale $r_scale +scr_ofsx -2.8 +scr_sbaralpha 1 +v_gunkick 2 +gamma 1.2 +contrast 1.5 +fov 85 +fog 0.02 -fitz

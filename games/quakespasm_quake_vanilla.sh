#!/bin/sh

set -e

config_game_dir="$HOME/games/quake"
compiled_qpakman="$HOME/src/qpakman/qpakman"
compiled_quakespasm="$HOME/src/quakespasm-quakespasm/Quake/quakespasm"

find_qpakman() {
    command -v qpakman 2>/dev/null || [ -f "$compiled_qpakman" ] && echo "$compiled_qpakman"
}

find_quakespasm() {
    command -v quakespasm 2>/dev/null || [ -f "$compiled_quakespasm" ] && echo "$compiled_quakespasm"
}

get_random_map() {
    mapfile=$(find "$config_game_dir"/*/{maps/*.bsp,pak0.pak} -type f | shuf -n 1)

    case "$mapfile" in
        *pak*)
            pakfile="$mapfile"
            qpakman_cmd=$(find_qpakman) || { echo "qpakman no encontrado"; exit 1; }
            mapname=$( "$qpakman_cmd" -l "$pakfile" | grep 'maps/.*\.bsp' | awk '{ print $5 }' | shuf -n 1 )
            mapdir=$(basename "$(dirname "$pakfile")")
            ;;
        *.bsp)
            mapname=$(basename "${mapfile%.*}")
            mapdir=$(basename "$(dirname "$(dirname "$mapfile")")")
            ;;
        *)
            echo "No se pudo determinar un mapa válido"
            exit 1
            ;;
    esac
}

get_random_map

echo "INFO: Map directory: $mapdir"
echo "INFO: Map name: $mapname"

quakespasm_cmd=$(find_quakespasm) || { echo "quakespasm no encontrado"; exit 1; }

set -x
"$quakespasm_cmd" \
    -current -basedir "$config_game_dir" -heapsize 524288 -zone 4096 -game "$mapdir" +map "$mapname" +skill 1 -fitz \
    +r_particles 2 +r_lerpmodels 0 +r_lerpmove 0 +r_viewmodel_quake 1 +r_scale 4 +scr_ofsx -2.8 +scr_sbaralpha 1 \
    +v_gunkick 2 +gamma 1.2 +contrast 1.5 +fov 85 +fog 0.02 +scr_showfps 1 \
    > /tmp/quakespasm.log
set +x

#!/bin/sh
# POSIX sh and utilities; dmenu and Quakespasm are the only application dependencies.
set -eu
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
root="$HOME/games/quake"
engine="$HOME/src/quakespasm/Quake/quakespasm"

catalog() {
    for directory in "$root"/*; do
        [ -d "$directory" ] || continue
        if [ -d "$directory/maps" ]; then
            find "$directory/maps" -type f -name '*.bsp' -print
        fi
        # One package entry per mod. The engine loads the remaining numbered PAKs.
        if [ -f "$directory/pak0.pak" ]; then
            printf '%s\n' "$directory/pak0.pak"
        fi
    done | LC_ALL=C sort -f
}

[ -d "$root" ] || { printf 'Missing directory: %s\n' "$root" >&2; exit 1; }
case $# in
    0) ;;
    1) case $1 in
        --list) catalog; exit ;;
        *) printf 'Usage: %s [--list]\n' "$0" >&2; exit 1 ;;
       esac ;;
    *) printf 'Usage: %s [--list]\n' "$0" >&2; exit 1 ;;
esac
command -v dmenu >/dev/null 2>&1 || { printf 'dmenu is required.\n' >&2; exit 1; }
[ -x "$engine" ] || engine=$(command -v quakespasm)
entries=$(catalog)
[ -n "$entries" ] || exit 0
selected=$(printf '%s\n' "$entries" | dmenu -i -l 20 -p 'Quake:') || exit 0
[ -n "$selected" ] || exit 0
# dmenu permits arbitrary text: only accept an actual catalog entry.
printf '%s\n' "$entries" | grep -F -x -e "$selected" >/dev/null || exit 1
[ -f "$selected" ] || exit 1
case "$selected" in
    "$root"/*) relative=${selected#"$root"/} ;;
    *) exit 1 ;;
esac
game=${relative%%/*}
case "$game" in
    ''|.|..|*[!A-Za-z0-9_.-]*) printf 'Unsupported game directory: %s\n' "$game" >&2; exit 1 ;;
esac
case "$relative" in
    "$game/maps/"*.bsp)
        map=${relative#"$game/maps/"}
        map=${map%.bsp}
        ;;
    "$game/pak0.pak") map=start ;;
    *) exit 1 ;;
esac
# Quake parses +map as console input, so reject console metacharacters.
case "$map" in
    ''|/*|*[!A-Za-z0-9_./-]*) printf 'Unsupported map name: %s\n' "$map" >&2; exit 1 ;;
esac
case "/$map/" in */../*|*/./*) exit 1 ;; esac
set -- "$engine" -width 1920 -height 1080 -fullscreen \
    -basedir "$root" -heapsize 256000 -zone 4096
case "$game" in
    id1) ;;
    hipnotic|rogue|quoth) set -- "$@" "-$game" ;;
    *) set -- "$@" -game "$game" ;;
esac
log_dir="${XDG_CACHE_HOME:-$HOME/.cache}/quake-launcher"
mkdir -p "$log_dir"
# Configure skill before loading the map. Keep normal dmenu cancellation silent.
exec "$@" +exec "$root/id1/autoexec.cfg" +skill 1 +map "$map" -fitz \
    > "$log_dir/quakespasm.log" 2>&1

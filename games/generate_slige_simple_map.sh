#!/bin/sh
set -eu

slige_dir="$HOME/src/slige-simple"
slige_bin="$slige_dir/slige"
slige_config="$slige_dir/slige.cfg"
bsp_bin="$HOME/games/doom/tools/bsp/bsp-5.2/bsp"
output_dir="$HOME/games/doom/maps/slige/simple"

rooms="${1:-100}"
seed="${3:-$(date +%s)}"
output="${2:-$output_dir/slige_simple_${seed}.wad}"
population_option="${4:-}"

case "$rooms" in
  ''|*[!0-9]*) printf 'ERROR: rooms must be a positive integer\n' >&2; exit 2 ;;
esac
case "$seed" in
  ''|*[!0-9]*) printf 'ERROR: seed must be a positive integer\n' >&2; exit 2 ;;
esac
[ "$rooms" -gt 0 ] || { printf 'ERROR: rooms must be greater than zero\n' >&2; exit 2; }
case "$population_option" in
  ''|--melee-only|--no-monsters) ;;
  *) printf 'ERROR: fourth argument must be --melee-only or --no-monsters\n' >&2; exit 2 ;;
esac

[ -x "$slige_bin" ] || make -C "$slige_dir"
[ -f "$slige_config" ] || { printf 'ERROR: missing %s\n' "$slige_config" >&2; exit 1; }
[ -x "$bsp_bin" ] || { printf 'ERROR: missing %s\n' "$bsp_bin" >&2; exit 1; }

mkdir -p "$(dirname "$output")"
work_dir="$(mktemp -d /tmp/slige-simple.XXXXXX)"
trap 'rm -rf "$work_dir"' EXIT HUP INT TERM
raw_wad="$work_dir/raw.wad"

set -- "$slige_bin" \
  -config "$slige_config" \
  -doom2 -map01 -levels 1 -simple -huge -rooms "$rooms"
[ "$population_option" != "--melee-only" ] || set -- "$@" -meleeonly
[ "$population_option" != "--no-monsters" ] || set -- "$@" -nomonsters
set -- "$@" -seed "$seed" -nocustom -outfile "$raw_wad"
"$@"

"$bsp_bin" -q "$raw_wad" -o "$output"

printf 'Map:  %s\n' "$output"
printf 'Seed: %s\n' "$seed"
printf 'Rooms requested: %s\n' "$rooms"

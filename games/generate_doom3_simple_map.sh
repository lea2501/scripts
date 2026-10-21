#!/bin/sh
set -eu

generator="$HOME/src/doom3-simple-map/generate_slige_map.py"

exec python3 "$generator" "$@"

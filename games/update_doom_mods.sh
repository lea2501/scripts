#!/bin/sh
set -eu

if [ "$#" -eq 0 ]; then
  set -- check
else
  case "$1" in
    list|check|download) ;;
    *) set -- check "$@" ;;
  esac
fi

exec /home/lea/games/doom/tools/custom/doom_mod_updates.py "$@"

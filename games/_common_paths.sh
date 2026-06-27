#!/bin/sh
# Common paths for game scripts
game_dir="$HOME/games/doom"

iwad_path() {
  game="$1"

  candidates="$game_dir/maps/iwads/$game.wad $game_dir/maps/original/$game.wad"

  for candidate in $candidates; do
    if [ -f "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  printf 'ERROR: IWAD not found for %s\n' "$game" >&2
  return 1
}

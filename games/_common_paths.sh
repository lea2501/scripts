#!/bin/sh
# Common paths for game scripts
game_dir="$HOME/games/doom"

game_bin() {
  compiled_bin="$1"
  installed_name="$2"

  if [ -x "$compiled_bin" ]; then
    printf '%s\n' "$compiled_bin"
  elif command -v "$installed_name" >/dev/null 2>&1; then
    command -v "$installed_name"
  else
    printf 'ERROR: executable not found: %s or %s in PATH\n' \
      "$compiled_bin" "$installed_name" >&2
    return 1
  fi
}

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

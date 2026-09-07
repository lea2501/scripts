#!/bin/bash

set -euo pipefail

hatari="${HOME}/src/hatari/install/bin/hatari"
machine="st"
tos_args=()

if [ ! -x "${hatari}" ]; then
  printf 'Hatari is not installed. Run:\n  %s\n' \
    "${HOME}/src/scripts/devuan/games/install_hatari.sh" >&2
  exit 1
fi

if [ "${1:-}" = "--machine" ]; then
  if [ "$#" -lt 2 ]; then
    printf 'Uso: %s [--machine st|ste|megast|megaste|tt|falcon] [imagen]\n' "$0" >&2
    exit 2
  fi
  machine="$2"
  shift 2
fi

case "${machine}" in
  st|ste|megast|megaste|tt|falcon) ;;
  *)
    printf 'Máquina no soportada: %s\n' "${machine}" >&2
    exit 2
    ;;
esac

if [ "$#" -gt 1 ]; then
  printf 'Uso: %s [--machine st|ste|megast|megaste|tt|falcon] [imagen]\n' "$0" >&2
  exit 2
fi

if [ -n "${TOS_ROM:-}" ]; then
  if [ ! -f "${TOS_ROM}" ]; then
    printf 'TOS_ROM no existe: %s\n' "${TOS_ROM}" >&2
    exit 1
  fi
  tos_args=(--tos "${TOS_ROM}")
else
  for tos_rom in \
    "${HOME}/games/emu/atari_st/bios/tos104.img" \
    "${HOME}/games/emu/atari_st/bios/tos102.img" \
    "${HOME}/games/emu/atari_st/bios/tos206.img"; do
    if [ -f "${tos_rom}" ]; then
      tos_args=(--tos "${tos_rom}")
      break
    fi
  done
fi

if [ "$#" -eq 0 ]; then
  exec "${hatari}" --machine "${machine}" "${tos_args[@]}"
fi

exec "${hatari}" --machine "${machine}" "${tos_args[@]}" "$1"

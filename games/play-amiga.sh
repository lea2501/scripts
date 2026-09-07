#!/bin/bash

set -euo pipefail

amiberry="${HOME}/src/amiberry/install/bin/amiberry"
model="A500"

if [ ! -x "${amiberry}" ]; then
  printf 'Amiberry is not installed. Run:\n  %s\n' \
    "${HOME}/src/scripts/devuan/games/install_amiberry.sh" >&2
  exit 1
fi

if [ "${1:-}" = "--model" ]; then
  if [ "$#" -lt 2 ]; then
    printf 'Uso: %s [--model A500|A1200|CD32] [imagen ...]\n' "$0" >&2
    exit 2
  fi
  model="$2"
  shift 2
fi

case "${model}" in
  A500|A500P|A600|A1200|CD32|CDTV) ;;
  *)
    printf 'Modelo no soportado por este launcher: %s\n' "${model}" >&2
    exit 2
    ;;
esac

if [ "$#" -eq 0 ]; then
  exec "${amiberry}" --model "${model}"
fi

if [ "$#" -eq 1 ]; then
  exec "${amiberry}" --model "${model}" -G "$1"
fi

if [ "$#" -gt 4 ]; then
  printf 'Se admiten hasta cuatro imágenes de disquete.\n' >&2
  exit 2
fi

disk_args=()
drive=0
for disk_image in "$@"; do
  disk_args+=("-${drive}" "${disk_image}")
  drive=$((drive + 1))
done

exec "${amiberry}" --model "${model}" -G "${disk_args[@]}"


#!/bin/sh
set -eu

usage() {
    echo "Uso:"
    echo "  $0 mod_dir"
    echo "  $0 mod_dir output_mod_dir"
    echo
    echo "Ejemplo:"
    echo "  $0 ~/games/quake/qbj3"
    exit 1
}

if [ $# -ne 1 ] && [ $# -ne 2 ]; then
    usage
fi

SRC="${1%/}"
if [ ! -d "$SRC" ]; then
    echo "No existe el directorio del mod: $SRC" >&2
    exit 1
fi

if [ ! -d "$SRC/maps" ]; then
    echo "No existe el subdirectorio maps: $SRC/maps" >&2
    exit 1
fi

if [ $# -eq 2 ]; then
    DST="${2%/}"
else
    DST="${SRC}_explore"
fi

if [ -e "$DST" ]; then
    echo "El destino ya existe, no lo piso: $DST" >&2
    exit 1
fi

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
NOMONSTERS="$SCRIPT_DIR/quakespasm_nomonsters.sh"

if [ ! -x "$NOMONSTERS" ]; then
    echo "No encuentro el script ejecutable: $NOMONSTERS" >&2
    exit 1
fi

MAP_COUNT="$(find "$SRC/maps" -maxdepth 1 -type f -name '*.bsp' | wc -l)"
if [ "$MAP_COUNT" -eq 0 ]; then
    echo "No hay mapas .bsp en: $SRC/maps" >&2
    exit 1
fi

cp -a "$SRC" "$DST"

find "$DST/maps" -maxdepth 1 -type f -name '*.bsp' | sort | while IFS= read -r bsp; do
    "$NOMONSTERS" "$bsp" "$bsp"
done

echo "Mod generado: $DST"
echo "Mapas procesados: $MAP_COUNT"

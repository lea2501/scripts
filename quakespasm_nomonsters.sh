#!/bin/sh
set -eu

usage() {
    echo "Uso:"
    echo "  $0 input.bsp"
    echo "  $0 input.bsp output.bsp"
    echo "  $0 --strip-pickups input.bsp output.bsp"
    exit 1
}

STRIP_PICKUPS=0
if [ "${1:-}" = "--strip-pickups" ]; then
    STRIP_PICKUPS=1
    shift
fi

if [ $# -ne 1 ] && [ $# -ne 2 ]; then
    usage
fi

INPUT="$1"
if [ ! -f "$INPUT" ]; then
    echo "No existe el BSP de entrada: $INPUT" >&2
    exit 1
fi

BASENAME="$(basename "$INPUT" .bsp)"

if [ $# -eq 2 ]; then
    OUTPUT="$2"
    OUTDIR="$(dirname "$OUTPUT")"
else
    OUTDIR="$HOME/games/quake/no_monsters/maps"
    OUTPUT="$OUTDIR/$BASENAME.bsp"
fi

BSPUTIL="${BSPUTIL:-}"
if [ -z "$BSPUTIL" ]; then
    if command -v bsputil >/dev/null 2>&1; then
        BSPUTIL="$(command -v bsputil)"
    else
        BSPUTIL="$HOME/src/ericw-tools/build-linux/bsputil/bsputil"
    fi
fi

if [ ! -x "$BSPUTIL" ]; then
    echo "No encuentro bsputil ejecutable: $BSPUTIL" >&2
    echo "Definilo con BSPUTIL=/ruta/a/bsputil $0 ..." >&2
    exit 1
fi

mkdir -p "$OUTDIR"

INPUT_REAL="$(readlink -f "$INPUT" 2>/dev/null || printf '%s\n' "$INPUT")"
OUTPUT_REAL="$(readlink -f "$OUTPUT" 2>/dev/null || printf '%s\n' "$OUTPUT")"
if [ "$INPUT_REAL" != "$OUTPUT_REAL" ]; then
    cp -f "$INPUT" "$OUTPUT"
fi

OUTBASE="$(basename "$OUTPUT" .bsp)"
ENT="$OUTDIR/$OUTBASE.ent"
ENT_BAK="$OUTDIR/${OUTBASE}_bak.ent"
ENT_NEW="$OUTDIR/${OUTBASE}_nomon.ent"

"$BSPUTIL" -extract-entities "$OUTPUT"
cp -f "$ENT" "$ENT_BAK"

awk -v strip_pickups="$STRIP_PICKUPS" '
BEGIN {
    RS = "}"
    ORS = ""
}

function skip_pickup(entity) {
    return entity ~ /"classname" "weapon_/ ||
        entity ~ /"classname" "item_shells"/ ||
        entity ~ /"classname" "item_spikes"/ ||
        entity ~ /"classname" "item_rockets"/ ||
        entity ~ /"classname" "item_cells"/ ||
        entity ~ /"classname" "item_health"/ ||
        entity ~ /"classname" "item_armor1"/ ||
        entity ~ /"classname" "item_armor2"/ ||
        entity ~ /"classname" "item_armorInv"/
}

NF {
    entity = $0 "}"

    if (entity ~ /"classname" "monster_/) next
    if (strip_pickups && skip_pickup(entity)) next

    if (entity ~ /"classname" "trigger_counter"/) {
        if (entity ~ /"count" "[^"]*"/) {
            gsub(/"count" "[^"]*"/, "\"count\" \"0\"", entity)
        } else {
            sub(/\n\}$/, "\n\"count\" \"0\"\n}", entity)
        }
    }

    print entity "\n"
}
' "$ENT" > "$ENT_NEW"

mv -f "$ENT_NEW" "$ENT"
"$BSPUTIL" -replace-entities "$ENT" "$OUTPUT"

echo "Mapa generado: $OUTPUT"
echo "Backup entidades originales: $ENT_BAK"

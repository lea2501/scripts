#!/bin/sh
set -eu

if [ $# -ne 2 ]; then
    echo "Uso: $0 input.bsp output.bsp"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

BSPUTIL="$HOME/src/ericw-tools/build-linux/bsputil/bsputil"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

cp "$INPUT" "$OUTPUT"

BASE_IN="$(basename "$INPUT" .bsp)"
BASE_OUT="$(basename "$OUTPUT" .bsp)"

ENT="$TMPDIR/$BASE_IN.ent"
ENT_BAK="$TMPDIR/$BASE_IN.bak.ent"
ENT_NEW="$TMPDIR/$BASE_OUT.ent"

# Extraer entidades del BSP de salida
"$BSPUTIL" -extract-entities "$OUTPUT" > "$ENT"

cp "$ENT" "$ENT_BAK"

awk '
BEGIN {
    RS="}"
    ORS=""
}
{
    entity=$0 "}"

    #
    # Eliminar monstruos
    #
    if (entity ~ /"classname" "monster_/) next

    #
    # Eliminar armas
    #
    if (entity ~ /"classname" "weapon_/) next

    #
    # Eliminar munición
    #
    if (entity ~ /"classname" "item_shells"/) next
    if (entity ~ /"classname" "item_spikes"/) next
    if (entity ~ /"classname" "item_rockets"/) next
    if (entity ~ /"classname" "item_cells"/) next

    #
    # Eliminar salud
    #
    if (entity ~ /"classname" "item_health"/) next

    #
    # Eliminar armaduras
    #
    if (entity ~ /"classname" "item_armor1"/) next
    if (entity ~ /"classname" "item_armor2"/) next
    if (entity ~ /"classname" "item_armorInv"/) next

    #
    # trigger_counter -> count = 0
    #
    if (entity ~ /"classname" "trigger_counter"/) {
        gsub(/"count" "[0-9]+"/, "\"count\" \"0\"", entity)
    }

    print entity "\n"
}
' "$ENT" > "$ENT_NEW"

#
# bsputil -replace-entities busca automáticamente
# un .ent con el mismo nombre base que el BSP
#
cp "$ENT_NEW" "$TMPDIR/$BASE_OUT.ent"

(
    cd "$TMPDIR"
    "$BSPUTIL" -replace-entities "$OUTPUT"
)

echo
echo "Mapa generado:"
echo "    $OUTPUT"
echo
echo "Backup entidades originales:"
echo "    $ENT_BAK"

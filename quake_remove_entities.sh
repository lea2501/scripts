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

BASE="$(basename "$INPUT" .bsp)"

ENT="$TMPDIR/$BASE.ent"
ENT_BAK="$TMPDIR/$BASE.bak.ent"
ENT_NEW="$TMPDIR/$BASE.new.ent"

# Extraer entidades
"$BSPUTIL" -extract-entities "$OUTPUT" > "$ENT"

cp "$ENT" "$ENT_BAK"

# Filtrar entidades
awk '
BEGIN {
    RS="}";
    ORS="";
}

{
    entity=$0 "}";

    if (entity ~ /"classname" "monster_/) next;
    if (entity ~ /"classname" "weapon_/) next;
    if (entity ~ /"classname" "item_shells"/) next;
    if (entity ~ /"classname" "item_spikes"/) next;
    if (entity ~ /"classname" "item_rockets"/) next;
    if (entity ~ /"classname" "item_cells"/) next;
    if (entity ~ /"classname" "item_health"/) next;
    if (entity ~ /"classname" "item_armor1"/) next;
    if (entity ~ /"classname" "item_armor2"/) next;
    if (entity ~ /"classname" "item_armorInv"/) next;

    print entity "\n";
}
' "$ENT" > "$ENT_NEW"

# bsputil espera un .ent con el mismo nombre base
cp "$ENT_NEW" "$TMPDIR/$(basename "$OUTPUT" .bsp).ent"

cd "$TMPDIR"

"$BSPUTIL" -replace-entities "$OUTPUT"

echo
echo "Generated:"
echo "    $OUTPUT"

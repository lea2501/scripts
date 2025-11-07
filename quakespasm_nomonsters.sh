#!/bin/sh
set -e
set -x

BSP="$1"
BASENAME=$(basename "${BSP%.bsp}")
BSPDIR="$(dirname "$BSP")"
OUTDIR="$HOME/games/quake/no_monsters/maps"
ENT="${BASENAME}.ent"
ENT_NOMON="${BASENAME}_nomon.ent"
#BSP_NOMON="${BASENAME}_nomon.bsp"

alias bsputil=$HOME/src/ericw-tools/build-linux/bsputil/bsputil

mkdir -p "$OUTDIR"

# Extraer entidades
cp "$BSP" "$OUTDIR/"
bsputil -extract-entities "$OUTDIR/$BASENAME.bsp"
cp "$OUTDIR/$ENT" "$OUTDIR/${BASENAME}_bak.ent"

# Quitar monstruos
awk '
BEGIN { keep=1 }
/^\{/ { buffer=$0; keep=1; next }
/^\}/ { buffer=buffer ORS $0; if (keep) print buffer; buffer=""; next }
/^"classname" "monster_/ { keep=0 }
{ buffer=buffer ORS $0 }
' "$OUTDIR/$ENT" > "$OUTDIR/$ENT_NOMON"
mv "$OUTDIR/$ENT_NOMON" "$OUTDIR/$ENT"

# Reemplazar entidades en una copia del BSP original
bsputil -replace-entities "$OUTDIR/$BASENAME.ent" "$OUTDIR/$BASENAME.bsp"

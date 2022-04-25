#!/bin/sh

if { [ -z "$1" ] || [ "$1" = -h ] || [ "$1" = --help ];}; then
  echo "Usage:"
  echo "  $(basename "$0") [chars_to_remove]"
  echo ""
  exit
fi

amount=$1
for dir in *; do
  cd "$dir" || return
  for i in *.*; do
     newName=$(echo "$i" | cut -c"$amount"-)
     mv -v "$i" "$newName"
  done
  cd .. || return
done
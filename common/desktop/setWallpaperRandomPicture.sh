#!/bin/sh

wallpaper=$(find "$HOME/pictures/wallpapers" -type f | awk '
    BEGIN { srand() }
    { count++; if (rand() < 1 / count) selected = $0 }
    END { print selected }
')

if [ -z "$wallpaper" ]; then
    echo "No wallpapers found in $HOME/pictures/wallpapers" >&2
    exit 1
fi

feh --bg-scale "$wallpaper"

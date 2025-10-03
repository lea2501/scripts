#!/bin/sh

for compat_dir in */; do
    [ -d "$compat_dir" ] || continue
    compat=$(basename "$compat_dir")

    cd "$compat_dir" || continue

    for tag_dir in */; do
        [ -d "$tag_dir" ] || continue
        tag=$(basename "$tag_dir")

        cd "$tag_dir" || continue

        for mod_dir in */; do
            [ -d "$mod_dir" ] || continue
            cd "$mod_dir" || continue

            title=$(basename "$mod_dir")
            ini_file="meta.ini"
            tags="$tag"
            args=""

            for txt in *.txt; do
                [ -f "$txt" ] || continue
                grep -qi "game" "$txt" && {
                    game_line=$(grep -i "game" "$txt" | head -n 1)
                    game=$(game_from_text "$game_line")
                }

                for word in weapons monsters gameplay graphics hud maps tc total_conversion; do
                    grep -iq "$word" "$txt" && tags="$tags,$word"
                done
            done

            files=$(find . -maxdepth 1 -type f \( -iname "*.wad" -o -iname "*.pk3" -o -iname "*.deh" \) | sort)
            for f in $files; do
                f_clean=$(basename "$f")
                args="$args $f_clean"
            done

            tags=$(echo "$tags" | sed 's/^,//;s/,,*/,/g')

            {
                echo "title=$title"
                echo "compat=$compat"
                echo "game=$game"
                echo "tags=$tags"
                [ -n "$args" ] && echo "args=$args"
            } > "$ini_file"

            cd ..
        done

        cd ..
    done

    cd ..
done

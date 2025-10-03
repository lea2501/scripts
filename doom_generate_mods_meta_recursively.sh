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
            args=""

            for f in *; do
                case "$f" in
                    *.wad|*.WAD|*.pk3|*.PK3|*.deh|*.DEH)
                        args="$args $f"
                        ;;
                esac
            done

            {
                echo "title=$title"
                echo "compat=$compat"
                echo "tags=$tag"
                [ -n "$args" ] && echo "args=$args"
            } > "$ini_file"

            cd ..
        done

        cd ..
    done

    cd ..
done

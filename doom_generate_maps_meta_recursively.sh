#!/bin/sh
#set -x

# Mapea formato a engine por defecto
engine_for_format() {
    format=$1
    game=$2

    case "$format" in
        vanilla)
            case "$game" in
                heretic) echo "chocolate-heretic" ;;
                hexen) echo "chocolate-hexen" ;;
                *) echo "chocolate-doom" ;;
            esac
            ;;
        limit-removing)
            case "$game" in
                heretic) echo "crispy-heretic" ;;
                hexen) echo "crispy-hexen" ;;
                *) echo "crispy-doom" ;;
            esac
            ;;
        boom|mbf) echo "prboom+" ;;
        mbf21) echo "dsda-doom" ;;
        gzdoom) echo "gzdoom" ;;
        zdoom) echo "zdoom" ;;
        eternity) echo "eternity" ;;
        vavoom) echo "vavoom" ;;
        legacy) echo "legacy" ;;
        *) echo "unknown" ;;
    esac
}

get_game_from_path() {
    # Va dos niveles arriba desde el WAD para obtener el juego base
    dirname "$(dirname "$(pwd)")" | sed 's#.*/##'
}


slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_-.'
}

for format_dir in */; do
    [ -d "$format_dir" ] || continue
    cd "$format_dir" || continue

    for wad_dir in */; do
        [ -d "$wad_dir" ] || continue
        cd "$wad_dir" || continue

        ini_file="meta.ini"
        wad_name=$(basename "$wad_dir")
        format=$(basename "$(dirname "$(pwd)")")
        title="$wad_name"
        game=$(get_game_from_path)
        engine=$(engine_for_format "$format" "$game")

        tags=""
        args=""
        iwad=""

        # Buscar todos los .txt excluyendo los irrelevantes
        found_txts=""
        for txt in *.txt; do
            [ -f "$txt" ] || continue
            case "$(echo "$txt" | tr '[:upper:]' '[:lower:]')" in
                *changelog*|*readme*|*history*|*credits*|*dmatch*|*singcoop*|*weapons*|*story*|*about*|*_dm*|*instructions*|*mp3*)
                    continue
                    ;;
                *)
                    found_txts="$found_txts $txt"
                    ;;
            esac
        done

        # Procesar cada .txt válido
        for txt_file in $found_txts; do
            grep -iq "slaughter" "$txt_file" && tags="$tags,slaughter"
            grep -iq "puzzle" "$txt_file" && tags="$tags,puzzle"
            grep -iq "megawad" "$txt_file" && tags="$tags,megawad"
            grep -iq "cooperative" "$txt_file" && tags="$tags,cooperative"

            # Buscar complevel
            complevel=$(grep -i "complevel" "$txt_file" | head -n 1 | sed 's/[^0-9]*\([0-9][0-9]*\).*/\1/')
            [ -n "$complevel" ] && args="$args -complevel $complevel"

#            # Buscar IWAD
#            iwad_line=$(grep -i "^Game[[:space:]]*:" "$txt_file" | head -n 1)
#            case "$(echo "$iwad_line" | tr '[:upper:]' '[:lower:]')" in
#                *doom 2*|*doom2*|*doom ii*) iwad="doom2" ;;
#                *tnt*) iwad="tnt" ;;
#                *plutonia*) iwad="plutonia" ;;
#                *heretic*) iwad="heretic" ;;
#                *hexen*) iwad="hexen" ;;
#                *strife*) iwad="strife" ;;
#            esac
        done

        # Añadir tag si el formato es deathmatch
        echo "$format" | grep -iq "deathmatch" && tags="$tags,deathmatch"

        # Limpiar coma inicial o dobles
        tags=$(echo "$tags" | sed 's/^,//;s/,,/,/g')

        # Escribir INI
        {
            echo "title=$title"
            echo "engine=$engine"
            echo "format=$format"
            [ -n "$iwad" ] && echo "iwad=$iwad"
            [ -n "$tags" ] && echo "tags=$tags"
            [ -n "$complevel" ] && echo "complevel=$complevel"
            [ -n "$args" ] && echo "args=$args"
        } > "$ini_file"

        cd ..
    done

    cd ..
done

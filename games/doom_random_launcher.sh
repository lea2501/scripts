#!/bin/sh
set -u

dry_run=false
case ${1-} in
  --dry-run) dry_run=true ;;
  '') ;;
  *) printf 'Uso: %s [--dry-run]\n' "$0" >&2; exit 2 ;;
esac

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd)
. "$SCRIPT_DIR/_common_paths.sh"
. "$SCRIPT_DIR/_common_mods_vanilla.sh"
. "$SCRIPT_DIR/_common_mods_zdoom.sh"

tmp_dir=${TMPDIR:-/tmp}/doom-random-launcher.$$
(umask 077 && mkdir "$tmp_dir") || exit 1
trap 'rm -rf "$tmp_dir"' 0 1 2 15

choose() {
  choose_prompt=$1
  shift
  while :; do
    printf '\n%s\n' "$choose_prompt" >&2
    choose_number=1
    for choose_option do
      printf '  %d) %s\n' "$choose_number" "$choose_option" >&2
      choose_number=$((choose_number + 1))
    done
    printf '> ' >&2
    IFS= read -r choose_answer || exit 1
    case $choose_answer in
      *[!0-9]*|'') ;;
      *)
        if [ "$choose_answer" -ge 1 ] && [ "$choose_answer" -le "$#" ]; then
          eval "printf '%s\\n' \"\${$choose_answer}\""
          return
        fi
        ;;
    esac
    printf 'Opcion invalida.\n' >&2
  done
}

random_line() {
  awk 'BEGIN { srand() } { if (rand() * NR < 1) selected = $0 } END { print selected }'
}

available_version() {
  configured_file=$1
  version_dir=$2
  version_pattern=$3
  if [ -f "$configured_file" ]; then
    printf '%s\n' "$configured_file"
  else
    find "$version_dir" -type f -name "$version_pattern" -print 2>/dev/null |
      LC_ALL=C sort | awk '{ available = $0 } END { print available }'
  fi
}

mark_played() {
  played_meta=$1
  played_tmp=$(mktemp "${played_meta}.tmp.XXXXXX") || return 1
  if awk '
    BEGIN { written = 0 }
    /^played=/ {
      if (!written) print "played=yes"
      written = 1
      next
    }
    { print }
    END { if (!written) print "played=yes" }
  ' "$played_meta" > "$played_tmp"; then
    mv "$played_tmp" "$played_meta"
  else
    rm -f "$played_tmp"
    return 1
  fi
}

game=$(choose 'Juego:' doom doom2)
engine=$(choose 'Engine:' 'Chocolate Doom' 'Crispy Doom' 'PrBoom+' 'DSDA-Doom' UZDoom 'GZDoom (Flatpak)')

case $engine in
  'Chocolate Doom') formats='vanilla'; profile=$(choose 'Set de mods:' 'Sin mods' Vanilla) ;;
  'Crispy Doom') formats='vanilla limit-removing'; profile=$(choose 'Set de mods:' 'Sin mods' Vanilla Improved) ;;
  'PrBoom+') formats='vanilla limit-removing boom'; profile=$(choose 'Set de mods:' 'Sin mods' Vanilla Improved) ;;
  'DSDA-Doom') formats='vanilla limit-removing boom mbf21'; profile=$(choose 'Set de mods:' 'Sin mods' Vanilla Improved) ;;
  UZDoom|'GZDoom (Flatpak)')
    formats='vanilla limit-removing boom mbf21 zdoom'
    if [ "$game" = doom2 ]; then
      profile=$(choose 'Set de mods:' 'Sin mods' Vanilla Improved 'Beautiful Doom' 'Brutal Doom' 'Project Brutality' 'Smooth Doom + NashGore' 'Russian Overkill' 'Dark Doom Creatures')
    else
      profile=$(choose 'Set de mods:' 'Sin mods' Vanilla Improved 'Beautiful Doom' 'Brutal Doom' 'Project Brutality')
    fi
    ;;
esac

mod_files=
case $profile in
  'Sin mods') ;;
  Vanilla)
    mod_files=$mods_vanilla_doom
    case $engine in UZDoom|'GZDoom (Flatpak)') mod_files="$mod_files $mods_zdoom_bullet_time" ;; esac
    ;;
  Improved)
    mod_files=$mods_vanilla_doom_improved
    case $engine in UZDoom|'GZDoom (Flatpak)') mod_files="$mod_files $mods_zdoom_bullet_time" ;; esac
    ;;
  'Beautiful Doom')
    relighting_file=$(available_version "$mods_zdoom_relighting" "$game_dir/mods/zdoom/enhancements/relighting" 'relighting_*.pk3')
    [ -n "$relighting_file" ] || { printf 'No encontre Relighting.\n' >&2; exit 1; }
    mod_files="$mods_vanilla_doom $relighting_file $mods_zdoom_beautiful $mods_zdoom_bullet_time"
    ;;
  'Brutal Doom')
    brutal_file=$(available_version "$mods_zdoom_brutal" "$game_dir/mods/zdoom/brutal/brutal_doom" 'brutalv*.pk3')
    [ -n "$brutal_file" ] || { printf 'No encontre Brutal Doom.\n' >&2; exit 1; }
    mod_files="$mods_vanilla_doom $brutal_file $mods_zdoom_bullet_time"
    ;;
  'Project Brutality') mod_files="$mods_vanilla_doom $mods_zdoom_project_brutality $mods_zdoom_bullet_time" ;;
  'Smooth Doom + NashGore') mod_files="$game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad $mods_zdoom_smoothdoom $mods_zdoom_nashgore $mods_zdoom_bullet_time" ;;
  'Russian Overkill') mod_files="$game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad $game_dir/mods/zdoom/gameplay/russian_overkill/ro_3.0e.pk3 $mods_zdoom_bullet_time" ;;
  'Dark Doom Creatures')
    dark_dir=$game_dir/mods/zdoom/randomizer/dark_doom_creatures/latest
    mod_files="$game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad
$dark_dir/DMGMOD1.12c30h.wad
$dark_dir/DMGMOD1.38-Gothic-Nightmare-addon.wad
$dark_dir/DMGMOD-mutator_NOnightmares.wad
$dark_dir/DMGMOD-mutator_LESSzombiesMOREimps.wad
$dark_dir/DMGMOD-mutator_NOnewpowerups.wad
$dark_dir/DMGMOD-mutator_NOnewzombies.wad
$dark_dir/immerse_v104.pk3
$dark_dir/sm4BBgorev3.pk3
$mods_zdoom_bullet_time"
    ;;
esac

meta_candidates=$tmp_dir/meta-candidates
: > "$meta_candidates"
for format in $formats; do
  format_dir=$game_dir/maps/$game/$format
  [ -d "$format_dir" ] || continue
  find "$format_dir" -type d -name cds_raw -prune -o -type f -name meta.ini -print 2>/dev/null |
    while IFS= read -r meta; do
      awk -F= '$1 == "played" && $2 == "yes" { played = 1 } END { exit played ? 0 : 1 }' "$meta" || printf '%s\n' "$meta"
    done >> "$meta_candidates"
done

meta_file=$(random_line < "$meta_candidates")
[ -n "$meta_file" ] || { printf 'No quedan mapas sin jugar compatibles con %s para %s.\n' "$engine" "$game" >&2; exit 1; }

map_dir=${meta_file%/meta.ini}
pwad_candidates=$tmp_dir/pwad-candidates
find "$map_dir" -type f \( -name '*.wad' -o -name '*.WAD' -o -name '*.pk3' -o -name '*.PK3' -o -name '*.pk7' -o -name '*.PK7' \) -print |
  awk '{ lower = tolower($0) } lower !~ /(tex|res|fix|demo|mus)[^/]*\.(wad|pk3|pk7)$/' > "$pwad_candidates"
pwad_file=$(random_line < "$pwad_candidates")
[ -n "$pwad_file" ] || { printf 'No encontre un WAD/PK3 jugable en %s\n' "$map_dir" >&2; exit 1; }
iwad_file=$(iwad_path "$game") || exit 1

for required_file in "$pwad_file" $mod_files; do
  [ -f "$required_file" ] || { printf 'Falta el archivo requerido: %s\n' "$required_file" >&2; exit 1; }
done

printf '\nJuego:  %s\nEngine: %s\nMods:   %s\nMapa:   %s\n\n' "$game" "$engine" "$profile" "$pwad_file"
[ "$dry_run" = false ] || { printf 'Simulacion: no se abrio el juego ni se modifico el meta.ini.\n'; exit 0; }

case $engine in
  'Chocolate Doom') doom_bin=$(game_bin "$HOME/src/chocolate-doom/src/chocolate-doom" chocolate-doom) || exit 1; set -- "$doom_bin" -config "$game_dir/config/chocolate/config.ini" -fullscreen; save_option=-savedir; log=/tmp/chocolate-doom.log ;;
  'Crispy Doom') doom_bin=$(game_bin "$HOME/src/crispy-doom/src/crispy-doom" crispy-doom) || exit 1; set -- "$doom_bin" -config "$game_dir/config/crispy/config_vanilla.ini" -fullscreen; save_option=-savedir; log=/tmp/crispy-doom.log ;;
  'PrBoom+') doom_bin=$(game_bin "$HOME/src/prboom-plus/prboom2/prboom-plus" prboom-plus) || exit 1; set -- "$doom_bin" -config "$game_dir/config/prboom-plus/prboom-plus_vanilla.cfg" -vidmode gl -complevel 17 -width 1920 -height 1080 -fullscreen -geom 640x360f -aspect 16:9; save_option=-save; log=/tmp/prboom-plus.log ;;
  'DSDA-Doom') doom_bin=$(game_bin "$HOME/src/dsda-doom/prboom2/build/dsda-doom" dsda-doom) || exit 1; set -- "$doom_bin" -config "$game_dir/config/dsda-doom/dsda-doom_vanilla.cfg" -vidmode gl -complevel 17 -width 1920 -height 1080 -fullscreen -geom 640x360f -aspect 16:9; save_option=-save; log=/tmp/dsda-doom.log ;;
  UZDoom) doom_bin=$(game_bin "$HOME/src/UZDoom/build/uzdoom" uzdoom) || exit 1; set -- "$doom_bin" -config "$game_dir/config/zdoom/config_zdoom.ini" -width 1920 -height 1080 -fullscreen; save_option=-savedir; log=/tmp/uzdoom.log ;;
  'GZDoom (Flatpak)') set -- flatpak run org.zdoom.GZDoom -config "$game_dir/config/zdoom/config_zdoom.ini" -width 1920 -height 1080 -fullscreen; save_option=-savedir; log=/tmp/gzdoom.log ;;
esac

set -- "$@" -iwad "$iwad_file" -file "$pwad_file"
for mod_file in $mod_files; do set -- "$@" "$mod_file"; done
set -- "$@" "$save_option" "$game_dir/savegames/$game/" -skill 3 -warp 1
[ "$game" = doom ] && set -- "$@" 1

"$@" > "$log" 2>&1
status=$?
if [ "$status" -eq 0 ]; then
  mark_played "$meta_file" || { printf 'El juego termino bien, pero no pude actualizar %s\n' "$meta_file" >&2; exit 1; }
  printf 'Marcado como jugado: %s\n' "$meta_file"
else
  printf '%s termino con codigo %d; el mapa no fue marcado. Log: %s\n' "$engine" "$status" "$log" >&2
fi
exit "$status"

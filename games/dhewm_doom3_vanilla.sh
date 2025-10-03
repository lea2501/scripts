#!/bin/sh

param_game_dir="$HOME/games/doom3"
basegame=base
echo "INFO: iwad file: $basegame"
map_file=$(unzip -l $param_game_dir/${basegame}/pak000.pk4 */game/*.map \
  | grep maps/game/ | grep -v maps/game/mp/ | shuf -n 1 | awk -F/ '{print $3}')
echo "INFO: Map file: $map_file"
#mod_files="$param_game_dir/mods/vanilla/sound/pk_doom_sfx/pk_doom_sfx_20120224.wad $param_game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad $param_game_dir/mods/vanilla/enhancements/smoothed/smoothed.wad"

set -x
eval dhewm3 \
  +set r_fullscreen 1 \
  +set r_mode -1 \
  +set r_customWidth 1920 +set r_customHeight 1080 \
  +set fs_basepath $param_game_dir \
  +set fs_game $basegame \
  +set fs_game_base base \
  +seta com_allowconsole 1 \
  +seta r_brightness 1 \
  +seta r_gamma 1 \
  +seta r_renderer "best" \
  +seta com_videoRam "1024" \
  +seta com_machineSpec "3" \
  +seta r_shadows "1" \
  +seta r_skipBump "0" \
  +seta r_skipSpecular "0" \
  +seta r_skipNewAmbient "0" \
  +seta image_anisotropy "8" \
  +seta image_lodbias "0" \
  +seta image_filter "GL_LINEAR_MIPMAP_LINEAR" \
  +seta image_ignoreHighQuality "0" \
  +seta image_roundDown "0" \
  +seta image_forceDownSize "0" \
  +seta image_downSize "0" \
  +seta image_downSizeBump "0" \
  +seta image_downSizeSpecular "0" \
  +seta image_useCache "0" \
  +seta image_usePrecompressedTextures "0" \
  +seta image_useNormalCompression "0" \
  +seta image_useCompression "0" \
  +seta image_useAllFormats "1" \
  +seta g_showBrass "1" \
  +seta g_decals "1" \
  +seta g_doubleVision "1" \
  +seta g_bloodEffects "1" \
  +seta g_projectileLights "1" \
  +seta g_muzzleFlash "1" \
  +vid_restart \
  +map $(echo game/$(basename -- ${map_file%.*})) \
  > /tmp/dhewm3.log
set +x

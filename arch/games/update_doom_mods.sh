#!/bin/bash

game_dir=~/games/doom

downloadLatestFromGithub() {
  download_directory=$1
  github_repo=$2
  ext=$3
  cd || return
  mod_dir=${game_dir}/${download_directory}
  mkdir -p "$mod_dir"
  cd "$mod_dir" || return
  curl -O -L "$(curl -s https://api.github.com/repos/${github_repo}/releases/latest | jq -r ".assets[] | select(.name | test(\"${ext}\")) | .browser_download_url")"
}

downloadLatestFromGithub "mods/zdoom/brutal/brutal_doom/" "BLOODWOLF333/Brutal-Doom-Community-Expansion" ".pk3"
downloadLatestFromGithub "mods/zdoom/immerse/" "JRHard771/Immerse" ".pk3"
downloadLatestFromGithub "mods/zdoom/droplets/" "JRHard771/droplets" ".pk3"
downloadLatestFromGithub "mods/zdoom/darkdoomz/" "caligari87/darkdoomz" ".pk3"

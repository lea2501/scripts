#!/bin/bash
set -euo pipefail
su="${su:-sudo}"
$su apt-get install -y --no-install-recommends build-essential cmake git ninja-build pkg-config nasm libsdl2-dev libgtk-3-dev libvpx-dev libwebp-dev libopenal-dev libfluidsynth-dev libsndfile1-dev libmpg123-dev libbz2-dev zlib1g-dev
application="Raze"
repository="https://github.com/ZDoom/Raze.git"
source_dir="${HOME}/src/${application}"
zmusic_dir="${source_dir}/build/zmusic"
executable="${source_dir}/build/raze"
compile=false
mkdir -p "${HOME}/src"
if [ ! -d "${source_dir}/.git" ]; then
  git clone --recurse-submodules "${repository}" "${source_dir}"
  compile=true
else
  git -C "${source_dir}" fetch
  local_commit="$(git -C "${source_dir}" rev-parse HEAD)"
  remote_commit="$(git -C "${source_dir}" rev-parse '@{u}')"
  if [ "${local_commit}" != "${remote_commit}" ]; then
    git -C "${source_dir}" pull --ff-only
    git -C "${source_dir}" submodule update --init --recursive
    compile=true
  elif [ ! -x "${executable}" ]; then
    compile=true
  else
    printf '%s is already up to date; skipping compilation.\n' "${application}"
  fi
fi
if [ "${compile}" = true ]; then
  if [ ! -d "${zmusic_dir}/.git" ]; then
    git clone https://github.com/ZDoom/ZMusic.git "${zmusic_dir}"
  else
    git -C "${zmusic_dir}" pull --ff-only
  fi
  cmake -S "${zmusic_dir}" -B "${zmusic_dir}/build" -DCMAKE_BUILD_TYPE=Release -G Ninja
  cmake --build "${zmusic_dir}/build"
  cmake -S "${source_dir}" -B "${source_dir}/build" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_PREFIX_PATH="${zmusic_dir}/build" -DPK3_QUIET_ZIPDIR=ON -G Ninja
  cmake --build "${source_dir}/build"
fi
printf '\nRaze is available at: %s\n' "${executable}"

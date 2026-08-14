#!/bin/bash

set -euo pipefail

# Set superuser privileges command if not set.
su="${su:-sudo}"

# Build dependencies documented by yquake2remaster for Debian.
$su apt-get install -y \
  build-essential ccache git pkg-config \
  libgl1-mesa-dev libsdl3-dev libopenal-dev libcurl4-openssl-dev \
  libavformat-dev libswscale-dev libvulkan-dev

application="yquake2remaster"
repository="https://github.com/yquake2/yquake2remaster.git"
source_dir="${HOME}/src/${application}"
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
    git -C "${source_dir}" submodule sync --recursive
    git -C "${source_dir}" submodule update --init --recursive
    compile=true
  else
    printf '%s is already up to date; skipping compilation.\n' "${application}"
  fi
fi

if [ "${compile}" = true ]; then
  # The upstream Unix build produces a portable tree in release/.
  make -C "${source_dir}" -j"$(nproc)"

  printf '\nBuild complete: %s/release/quake2\n' "${source_dir}"
  printf 'Example: %s/release/quake2 -datadir %s/games/quake2-enhanced\n' \
    "${source_dir}" "${HOME}"
fi

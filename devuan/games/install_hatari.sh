#!/bin/bash

set -euo pipefail

su="${su:-sudo}"

$su apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  ninja-build \
  pkg-config \
  libsdl2-dev \
  zlib1g-dev \
  libpng-dev \
  libreadline-dev \
  libcapstone-dev \
  libudev-dev

application="Hatari"
repository="https://framagit.org/hatari/hatari.git"
source_dir="${HOME}/src/hatari"
build_dir="${source_dir}/build"
install_dir="${source_dir}/install"
executable="${install_dir}/bin/hatari"
compile=false

mkdir -p "${HOME}/src"
mkdir -p "${HOME}/games/emu/atari_st/bios"

if [ ! -d "${source_dir}/.git" ]; then
  git clone "${repository}" "${source_dir}"
  compile=true
else
  git -C "${source_dir}" fetch --prune
  local_commit="$(git -C "${source_dir}" rev-parse HEAD)"
  remote_commit="$(git -C "${source_dir}" rev-parse '@{u}')"

  if [ "${local_commit}" != "${remote_commit}" ]; then
    git -C "${source_dir}" pull --ff-only
    compile=true
  elif [ ! -x "${executable}" ]; then
    compile=true
  else
    printf '%s is already up to date; skipping compilation.\n' "${application}"
  fi
fi

if [ "${compile}" = true ]; then
  cmake -S "${source_dir}" -B "${build_dir}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${install_dir}" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -G Ninja
  cmake --build "${build_dir}"
  cmake --install "${build_dir}"
fi

printf '\nHatari is available at: %s\n' "${executable}"

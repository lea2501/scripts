#!/bin/bash

set -euo pipefail

su="${su:-sudo}"

$su apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  ninja-build \
  pkg-config \
  libsdl3-dev \
  libsdl3-image-dev \
  libflac-dev \
  libmpg123-dev \
  libpng-dev \
  libmpeg2-4-dev \
  libserialport-dev \
  libportmidi-dev \
  libenet-dev \
  libpcap-dev \
  libzstd-dev \
  libcurl4-openssl-dev \
  nlohmann-json3-dev \
  libdbus-1-dev

application="Amiberry"
repository="https://github.com/BlitterStudio/amiberry.git"
source_dir="${HOME}/src/amiberry"
build_dir="${source_dir}/build"
install_dir="${source_dir}/install"
executable="${install_dir}/bin/amiberry"
compile=false

mkdir -p "${HOME}/src"
mkdir -p "${HOME}/games/emu/amiga/bios"

if [ ! -d "${source_dir}/.git" ]; then
  git clone --recurse-submodules "${repository}" "${source_dir}"
  compile=true
else
  git -C "${source_dir}" fetch --prune
  local_commit="$(git -C "${source_dir}" rev-parse HEAD)"
  remote_commit="$(git -C "${source_dir}" rev-parse '@{u}')"

  if [ "${local_commit}" != "${remote_commit}" ]; then
    git -C "${source_dir}" pull --ff-only
    git -C "${source_dir}" submodule sync --recursive
    git -C "${source_dir}" submodule update --init --recursive
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

printf '\nAmiberry is available at: %s\n' "${executable}"

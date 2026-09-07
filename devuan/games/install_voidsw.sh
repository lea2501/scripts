#!/bin/bash
set -euo pipefail
su="${su:-sudo}"
$su apt-get install -y --no-install-recommends build-essential git nasm pkg-config libsdl2-dev libsdl2-mixer-dev libflac-dev libvorbis-dev libvpx-dev libgtk-3-dev libgl1-mesa-dev libglu1-mesa-dev
application="eduke32"
repository="https://voidpoint.io/terminx/eduke32.git"
source_dir="${HOME}/src/${application}"
executable="${source_dir}/voidsw"
compile=false
mkdir -p "${HOME}/src"
if [ ! -d "${source_dir}/.git" ]; then
  git clone "${repository}" "${source_dir}"
  compile=true
else
  git -C "${source_dir}" fetch
  local_commit="$(git -C "${source_dir}" rev-parse HEAD)"
  remote_commit="$(git -C "${source_dir}" rev-parse '@{u}')"
  if [ "${local_commit}" != "${remote_commit}" ]; then
    git -C "${source_dir}" pull --ff-only
    compile=true
  elif [ ! -x "${executable}" ]; then
    compile=true
  else
    printf 'VoidSW is already up to date; skipping compilation.\n'
  fi
fi
if [ "${compile}" = true ]; then
  make -C "${source_dir}" -j"$(nproc)" voidsw
fi
printf '\nVoidSW is available at: %s\n' "${executable}"

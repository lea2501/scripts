#!/bin/bash
set -euo pipefail
su="${su:-sudo}"
$su apt-get install -y --no-install-recommends build-essential git scons libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libphysfs-dev
application="dxx-rebirth"
repository="https://github.com/dxx-rebirth/dxx-rebirth.git"
source_dir="${HOME}/src/${application}"
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
  elif [ ! -x "${source_dir}/d1x-rebirth" ] || [ ! -x "${source_dir}/d2x-rebirth" ]; then
    compile=true
  else
    printf '%s is already up to date; skipping compilation.\n' "${application}"
  fi
fi
if [ "${compile}" = true ]; then
  scons -C "${source_dir}" -j"$(nproc)" sdl2=1 builddir_prefix=build/
  d1_executable="$(find "${source_dir}/build" -type f -name d1x-rebirth -perm /111 -print -quit)"
  d2_executable="$(find "${source_dir}/build" -type f -name d2x-rebirth -perm /111 -print -quit)"
  ln -sfn "${d1_executable}" "${source_dir}/d1x-rebirth"
  ln -sfn "${d2_executable}" "${source_dir}/d2x-rebirth"
fi
printf '\nDXX-Rebirth is available at:\n  %s/d1x-rebirth\n  %s/d2x-rebirth\n' "${source_dir}" "${source_dir}"

#!/bin/bash
set -euo pipefail
su="${su:-sudo}"
$su apt-get install -y --no-install-recommends build-essential git libsdl2-dev libsdl2-mixer-dev
application="rottexpr"
repository="https://github.com/LTCHIPS/rottexpr.git"
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
  elif [ ! -x "${source_dir}/src/rottexpr" ]; then
    compile=true
  else
    printf '%s is already up to date; skipping compilation.\n' "${application}"
  fi
fi
if [ "${compile}" = true ]; then
  make -C "${source_dir}/src" clean ROTT=rottexpr
  make -C "${source_dir}/src" -j"$(nproc)" ROTT=rottexpr
  make -C "${source_dir}/src" clean ROTT=rottexpr-shareware
  make -C "${source_dir}/src" -j"$(nproc)" SHAREWARE=1 ROTT=rottexpr-shareware
  make -C "${source_dir}/src" clean ROTT=rottexpr-superrott
  make -C "${source_dir}/src" -j"$(nproc)" SUPERROTT=1 ROTT=rottexpr-superrott
  make -C "${source_dir}/src" clean ROTT=rottexpr-site-license
  make -C "${source_dir}/src" -j"$(nproc)" SITELICENSE=1 ROTT=rottexpr-site-license
fi
printf '\nROTTEXPR executables are available in: %s/src\n' "${source_dir}"

#!/bin/bash

set -euo pipefail

# Set superuser privileges command if not set.
su="${su:-sudo}"

# Build dependencies documented by ReflectionHLE for Linux.
$su apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  ninja-build \
  pkg-config \
  libsdl3-dev \
  libspeexdsp-dev

application="ReflectionHLE"
repository="https://github.com/ReflectionHLE/ReflectionHLE.git"
source_dir="${HOME}/src/${application}"
executable="${source_dir}/build/reflectionhle"
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
    printf '%s is already up to date; skipping compilation.\n' "${application}"
  fi
fi

if [ "${compile}" = true ]; then
  cmake -S "${source_dir}" -B "${source_dir}/build" \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -G Ninja
  cmake --build "${source_dir}/build"
fi

printf '\nReflectionHLE is available at: %s\n' "${executable}"

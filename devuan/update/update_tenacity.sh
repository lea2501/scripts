#!/usr/bin/env bash
set -euo pipefail

# Build/update Tenacity from the upstream default branch (development).
# Debian 12+/Devuan Daedalus+; dependencies come from the distribution.
# Run as your regular user: sudo is used only for apt dependencies.
# Tenacity stays in ~/src/tenacity; no system installation is performed.
# Optional: TENACITY_JOBS=2 ./update_tenacity.sh
# Sources: https://codeberg.org/tenacityteam/tenacity/src/branch/main/BUILDING.md

if [ -z "${su+x}" ]; then
  su="sudo"
fi
# Keep the privilege-command convention used by the other update scripts.
read -r -a privilege_command <<< "$su"

SOURCE_DIR="${TENACITY_SRC:-$HOME/src/tenacity}"
BUILD_DIR="$SOURCE_DIR/build"
JOBS="${TENACITY_JOBS:-2}"
REPOSITORY="https://codeberg.org/tenacityteam/tenacity.git"

# Retry interrupted transfers without changing global Git/TLS settings.
retry_download() {
  local attempt
  for attempt in 1 2 3; do
    if "$@"; then
      return 0
    fi
    if [ "$attempt" -lt 3 ]; then
      echo ">> Download failed ($attempt/3); retrying in 5 seconds..." >&2
      sleep 5
    fi
  done
  echo "Download failed after 3 attempts. Run this script again later." >&2
  return 1
}

if [[ ! "$JOBS" =~ ^[1-9][0-9]*$ ]]; then
  echo "TENACITY_JOBS must be a positive integer." >&2
  exit 1
fi

# Never overwrite local work or silently switch an existing checkout.
if [ -e "$SOURCE_DIR" ]; then
  if [ ! -d "$SOURCE_DIR/.git" ]; then
    echo "Not a Git checkout: $SOURCE_DIR" >&2
    exit 1
  fi
  if [ -n "$(git -C "$SOURCE_DIR" status --porcelain)" ]; then
    echo "Local changes in $SOURCE_DIR; commit or stash them first." >&2
    exit 1
  fi
  git -C "$SOURCE_DIR" symbolic-ref --quiet HEAD >/dev/null || {
    echo "Detached HEAD in $SOURCE_DIR; select a tracking branch first." >&2
    exit 1
  }
  git -C "$SOURCE_DIR" rev-parse --abbrev-ref '@{upstream}' >/dev/null
fi

echo ">> Installing Tenacity build dependencies..."
"${privilege_command[@]}" apt-get update
"${privilege_command[@]}" apt-get install -y \
  build-essential ca-certificates git cmake ninja-build ccache pkg-config \
  python3 gettext ffmpeg \
  libavcodec-dev libavformat-dev libavutil-dev libexpat1-dev \
  libflac++-dev libglib2.0-dev libgtk-3-dev libid3tag0-dev \
  libjack-jackd2-dev liblilv-dev libmpg123-dev libmp3lame-dev \
  libogg-dev libpng-dev portaudio19-dev libportmidi-dev libportsmf-dev \
  libserd-dev libsndfile1-dev libsord-dev libsoundtouch-dev libsoxr-dev \
  libsuil-dev libtwolame-dev vamp-plugin-sdk libvorbis-dev lv2-dev \
  zlib1g-dev libjpeg-dev libtiff-dev liblzma-dev libsqlite3-dev \
  libzip-dev zipcmp zipmerge ziptool rapidjson-dev \
  wx-common wx3.2-headers libwxgtk3.2-dev \
  libopus-dev libopusfile-dev libwavpack-dev libmatroska-dev

if [ ! -d "$SOURCE_DIR/.git" ]; then
  mkdir -p "$(dirname "$SOURCE_DIR")"
  # Only download the current source snapshot, not the entire Audacity history.
  retry_download git -c http.version=HTTP/1.1 clone --depth 1 \
    "$REPOSITORY" "$SOURCE_DIR"
else
  echo ">> Updating Tenacity..."
  retry_download git -c http.version=HTTP/1.1 -C "$SOURCE_DIR" fetch
  git -C "$SOURCE_DIR" merge --ff-only '@{upstream}'
fi

# Fetch the build submodules, without vcpkg or Flatpak packaging sources.
retry_download git -c http.version=HTTP/1.1 -C "$SOURCE_DIR" \
  submodule update --init --recursive --depth 1 \
  lib-src/libnyquist lib-src/pffft

echo ">> Configuring and building Tenacity ($JOBS jobs)..."
cmake -S "$SOURCE_DIR" -B "$BUILD_DIR" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DVCPKG=OFF \
  -DFFMPEG=ON
cmake --build "$BUILD_DIR" --parallel "$JOBS"

echo
echo "Done. Launch: $BUILD_DIR/Release/tenacity"
echo "Built commit: $(git -C "$SOURCE_DIR" rev-parse --short HEAD)"

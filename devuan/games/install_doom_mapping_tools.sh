#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Core command-line tools are installed by default.
# Optional GUI tools can be enabled with:
#   INSTALL_GUI=1 ./install_doom_mapping_tools.sh
#   DOWNLOAD_GUI_SOURCES=1 ./install_doom_mapping_tools.sh
#   DOWNLOAD_GUI_SOURCES=1 BUILD_UDB=1 ./install_doom_mapping_tools.sh

if [ -z "${su+x}" ]; then
  su="sudo"
fi

src_dir="$HOME/src"
tools_dir="$HOME/games/doom/tools"
mkdir -p "$src_dir" "$tools_dir"

$su apt-get install -y build-essential make cmake git pkg-config
$su apt-get install -y autoconf automake libtool flex bison
$su apt-get install -y zlib1g-dev zip unzip

clone_or_update() {
  application="$1"
  repository="$2"

  mkdir -p "$src_dir"
  cd "$src_dir" || return
  if [ ! -d "$application" ]; then
    git clone "$repository" "$application"
  else
    cd "$application" || return
    current_origin=$(git remote get-url origin || true)
    if [ "$current_origin" != "$repository" ]; then
      git remote set-url origin "$repository"
    fi
    git fetch
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse @{u})
    if [ "$LOCAL" != "$REMOTE" ]; then
      git pull
    fi
  fi
}

install_zdbsp() {
  clone_or_update zdbsp https://github.com/rheit/zdbsp.git
  cd "$src_dir/zdbsp" || return
  cmake -B build -DCMAKE_BUILD_TYPE=Release
  cmake --build build
  mkdir -p "$tools_dir/zdbsp"
  if [ -x build/zdbsp ]; then
    cp build/zdbsp "$tools_dir/zdbsp/zdbsp"
  elif [ -x build/Debug/zdbsp ]; then
    cp build/Debug/zdbsp "$tools_dir/zdbsp/zdbsp"
  elif [ -x build/Release/zdbsp ]; then
    cp build/Release/zdbsp "$tools_dir/zdbsp/zdbsp"
  else
    found=$(find build -type f -perm -111 -name zdbsp | head -n 1)
    if [ -n "$found" ]; then
      cp "$found" "$tools_dir/zdbsp/zdbsp"
    else
      echo "ERROR: zdbsp binary not found after build" >&2
      exit 1
    fi
  fi
}

install_deutex() {
  clone_or_update deutex https://github.com/Doom-Utils/deutex.git
  cd "$src_dir/deutex" || return
  ./bootstrap
  ./configure
  make
  mkdir -p "$tools_dir/deutex"
  if [ -x src/deutex ]; then
    cp src/deutex "$tools_dir/deutex/deutex"
  elif [ -x deutex ]; then
    cp deutex "$tools_dir/deutex/deutex"
  else
    found=$(find . -type f -perm -111 -name deutex | head -n 1)
    if [ -n "$found" ]; then
      cp "$found" "$tools_dir/deutex/deutex"
    else
      echo "ERROR: deutex binary not found after build" >&2
      exit 1
    fi
  fi
}

install_wadtools() {
  clone_or_update wadtools https://github.com/makise-homura/wadtools.git
  cd "$src_dir/wadtools" || return
  mkdir -p build
  cc wadbuild.c -o build/wadbuild
  cc wadxtract.c -o build/wadxtract
  cc wadfindthing.c -o build/wadfindthing
  mkdir -p "$tools_dir/wadtools"
  cp build/wadbuild build/wadxtract build/wadfindthing "$tools_dir/wadtools/"
}

install_gui_tools() {
  $su apt-get install -y eureka slade
}

download_gui_sources() {
  clone_or_update eureka-editor https://github.com/ioan-chera/eureka-editor.git
  clone_or_update SLADE https://github.com/sirjuddington/SLADE.git
  clone_or_update UltimateDoomBuilder https://github.com/UltimateDoomBuilder/UltimateDoomBuilder.git
  echo "INFO: Eureka source is in $src_dir/eureka-editor"
  echo "INFO: SLADE source is in $src_dir/SLADE"
  echo "INFO: Ultimate Doom Builder source is in $src_dir/UltimateDoomBuilder"
  echo "INFO: Linux build is experimental upstream. Set BUILD_UDB=1 to attempt it."
  if [ "$BUILD_UDB" = "1" ]; then
    $su apt-get install -y make g++ git libx11-dev libxfixes-dev mesa-common-dev mono-complete
    cd "$src_dir/UltimateDoomBuilder" || return
    make
  fi
}

install_zdbsp
install_deutex
install_wadtools

if [ "$INSTALL_GUI" = "1" ]; then
  install_gui_tools
fi

if [ "$DOWNLOAD_GUI_SOURCES" = "1" ]; then
  download_gui_sources
fi

echo "INFO: Doom mapping core tools installed:"
printf '%s\n' \
  "$tools_dir/zdbsp/zdbsp" \
  "$tools_dir/deutex/deutex" \
  "$tools_dir/wadtools/wadbuild" \
  "$tools_dir/wadtools/wadxtract" \
  "$tools_dir/wadtools/wadfindthing"

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y cmake build-essential libsdl2-dev libopenal-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libvulkan-dev libncurses-dev

# Install ISPC (Intel SPMD Program Compiler)
ISPC_VERSION="1.25.0"
ISPC_DIR="$HOME/src/RBDOOM-3-BFG/tools/ispc/bin"
if [ ! -f "$ISPC_DIR/ispc" ]; then
  mkdir -p "$ISPC_DIR"
  wget -O /tmp/ispc.tar.gz "https://github.com/ispc/ispc/releases/download/v${ISPC_VERSION}/ispc-v${ISPC_VERSION}-linux.tar.gz"
  tar -xzf /tmp/ispc.tar.gz -C /tmp
  cp /tmp/ispc-v${ISPC_VERSION}-linux/bin/ispc "$ISPC_DIR/"
  rm -rf /tmp/ispc-v${ISPC_VERSION}-linux /tmp/ispc.tar.gz
fi

# Install DXC (DirectX Shader Compiler) if not present
if ! command -v dxc &> /dev/null; then
  DXC_VERSION="1.8.2405"
  mkdir -p "$HOME/.local/bin"
  wget -O /tmp/dxc.tar.gz "https://github.com/microsoft/DirectXShaderCompiler/releases/download/v${DXC_VERSION}/linux_dxc_2024_05_24.x86_64.tar.gz"
  tar -xzf /tmp/dxc.tar.gz -C "$HOME/.local"
  chmod +x "$HOME/.local/bin/dxc"
  rm -f /tmp/dxc.tar.gz
  echo "DXC installed to ~/.local/bin/dxc"
  echo "Make sure ~/.local/bin is in your PATH"
fi

application=RBDOOM-3-BFG
repository=https://github.com/RobertBeckebans/RBDOOM-3-BFG.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone --recursive $repository
  cd $application || return
  export compile=true
else
  cd $application || return
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    echo "Need to pull"
    git pull
    git submodule update --init --recursive
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application/neo || return
  ./cmake-linux-release.sh
  cd ../build || return
  make -j$(nproc)
fi

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su pacman -Sy --noconfirm --needed base-devel make cmake binutils
$su pacman -Sy --noconfirm --needed fontconfig libxft libx11 fltk

application=Obsidian
repository=https://github.com/GTD-Carthage/Obsidian-Content.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone "$repository" "$application"
  cd $application || return
  export compile=true
else
  cd $application || return
  current_origin=$(git remote get-url origin || true)
  if [ "$current_origin" != "$repository" ]; then
    git remote set-url origin "$repository"
  fi
  #git pull
  pwd
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    pwd
    echo "Need to pull"
    git pull
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application || return
  cmake -B build -DCMAKE_BUILD_TYPE=Release
  cmake --build build
fi

config_dir="$HOME/games/doom/config/obsidian"
mkdir -p "$config_dir"
if [ -f "$HOME/.local/share/Obsidian/CONFIG.txt" ]; then
  cp "$HOME/.local/share/Obsidian/CONFIG.txt" "$config_dir/CONFIG.txt"
fi
if [ -f "$HOME/.local/share/Obsidian/OPTIONS.txt" ]; then
  cp "$HOME/.local/share/Obsidian/OPTIONS.txt" "$config_dir/OPTIONS.txt"
fi

#!/usr/bin/env bash
set -euo pipefail

# Pi + extensions and Engram 3.6.0 for the current user.
# Requires Node.js >= 22.19.0 and npm (e.g. installed through nvm).
if (( EUID == 0 )); then
  echo 'Run this script as your regular user, without sudo.' >&2
  exit 1
fi
if [[ $(uname -s) != Linux || $(uname -m) != x86_64 ]]; then
  echo 'The requested Engram archive requires Linux x86_64.' >&2
  exit 1
fi
for cmd in node npm curl tar install; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd. Install Node.js >= 22.19.0, npm, curl and tar first." >&2
    exit 1
  fi
done
node -e 'const [a,b] = process.versions.node.split(".").map(Number); if(a<22 || (a===22 && b<19)) { console.error("Pi requires Node.js >= 22.19.0"); process.exit(1); }'

mkdir -p "$HOME/bin"
# Persist the PATH for login shells and interactive Bash, without duplicating it.
path_line='case ":$PATH:" in *":$HOME/bin:"*) ;; *) export PATH="$HOME/bin:$PATH" ;; esac'
for profile in "$HOME/.profile" "$HOME/.bashrc"; do
  if ! grep -Fqx "$path_line" "$profile" 2>/dev/null; then
    printf '\n# User executables (Pi and Engram)\n%s\n' "$path_line" >> "$profile"
  fi
done
export PATH="$HOME/bin:$PATH"

# Keep Pi in its own user-owned npm prefix; no sudo or global npm config changes.
pi_prefix="$HOME/.local/share/pi-npm"
npm install --global --ignore-scripts --prefix "$pi_prefix" @earendil-works/pi-coding-agent
ln -sfn "$pi_prefix/bin/pi" "$HOME/bin/pi"

workdir=$(mktemp -d)
trap 'rm -rf -- "$workdir"' EXIT
engram_url='https://github.com/Gentleman-Programming/engram/releases/download/v3.6.0/engram_3.6.0_linux_amd64.tar.gz'
curl --fail --show-error --location --retry 3 "$engram_url" -o "$workdir/engram.tar.gz"
# Extract only the executable, never arbitrary archive paths.
member=$(tar -tzf "$workdir/engram.tar.gz" | awk '$0 == "engram" || $0 == "./engram" {print; exit}')
if [[ -z "$member" ]]; then
  echo 'The Engram archive does not contain the expected executable.' >&2
  exit 1
fi
tar -xOzf "$workdir/engram.tar.gz" "$member" > "$workdir/engram"
install -m 755 "$workdir/engram" "$HOME/bin/engram"

pi install npm:gentle-engram
pi install npm:pi-browser-harness
pi install npm:pi-subagents

command -v pi
command -v engram
echo 'Done. Pi, its three packages and Engram are installed.'
echo 'Open a new terminal (or run: export PATH="$HOME/bin:$PATH") before using pi.'

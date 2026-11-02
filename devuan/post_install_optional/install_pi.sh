#!/usr/bin/env bash
set -euo pipefail

# Pi + extensions and Engram 3.6.0 for the current user.
# Uses an existing compatible Node.js, or installs a private Node.js 24 runtime.
if (( EUID == 0 )); then
  echo 'Run this script as your regular user, without sudo.' >&2
  exit 1
fi
if [[ $(uname -s) != Linux || $(uname -m) != x86_64 ]]; then
  echo 'The requested Engram archive requires Linux x86_64.' >&2
  exit 1
fi
for cmd in curl tar install sha256sum awk xz; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd. Install curl, tar, coreutils and xz-utils first." >&2
    exit 1
  fi
done
workdir=$(mktemp -d)
trap 'rm -rf -- "$workdir"' EXIT

node_compatible() {
  command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1 &&
    node -e 'const [major, minor] = process.versions.node.split(".").map(Number); process.exit(major > 22 || (major === 22 && minor >= 19) ? 0 : 1)'
}

# Keep this runtime private to Pi, including future invocations of its launcher.
node_root="$HOME/.local/share/pi-node"
if [[ -x "$node_root/bin/node" && -x "$node_root/bin/npm" ]]; then
  export PATH="$node_root/bin:$PATH"
fi
if ! node_compatible; then
  echo "Pi requires Node.js >= 22.19.0; found $(node --version 2>/dev/null || echo none)."
  echo 'Installing a private Node.js 24 runtime for Pi...'
  node_url='https://nodejs.org/dist/latest-v24.x'
  curl --fail --show-error --location --retry 3 "$node_url/SHASUMS256.txt" -o "$workdir/SHASUMS256.txt"
  node_archive=$(awk '$2 ~ /^node-v24\.[0-9]+\.[0-9]+-linux-x64\.tar\.xz$/ {print $2}' "$workdir/SHASUMS256.txt")
  if [[ ! "$node_archive" =~ ^node-v24\.[0-9]+\.[0-9]+-linux-x64\.tar\.xz$ ]]; then
    echo 'Cannot identify the official Node.js 24 Linux x64 archive.' >&2
    exit 1
  fi
  curl --fail --show-error --location --retry 3 "$node_url/$node_archive" -o "$workdir/$node_archive"
  awk -v archive="$node_archive" '$2 == archive' "$workdir/SHASUMS256.txt" > "$workdir/node.sha256"
  (cd "$workdir" && sha256sum --check node.sha256)
  mkdir -p "$node_root"
  tar -xJf "$workdir/$node_archive" --strip-components=1 -C "$node_root"
  export PATH="$node_root/bin:$PATH"
fi
node_compatible
printf 'Using Node.js %s and npm %s\n' "$(node --version)" "$(npm --version)"

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
# Replace the old symlink with a launcher that also works with system Node 20.
cat > "$workdir/pi" <<'LAUNCHER'
#!/usr/bin/env bash
set -euo pipefail
if [[ -x "$HOME/.local/share/pi-node/bin/node" ]]; then
  export PATH="$HOME/.local/share/pi-node/bin:$PATH"
fi
exec "$HOME/.local/share/pi-npm/bin/pi" "$@"
LAUNCHER
# Unlink only the former launcher symlink; never overwrite its target.
if [[ -L "$HOME/bin/pi" ]]; then
  unlink "$HOME/bin/pi"
fi
install -m 755 "$workdir/pi" "$HOME/bin/pi"

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

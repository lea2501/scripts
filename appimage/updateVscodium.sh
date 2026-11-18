#!/usr/bin/env bash
set -euo pipefail

extensions_only=false
case "${1:-}" in
  '') ;;
  --extensions-only) extensions_only=true ;;
  -h|--help)
    echo "Usage: ${0##*/} [--extensions-only]"
    echo "Update VSCodium AppImage and install missing development extensions from Open VSX."
    echo "Run as your desktop user; extensions are installed in that user's profile."
    exit 0
    ;;
  *) echo "Unknown argument: $1" >&2; exit 1 ;;
esac
if (( EUID == 0 )); then
  echo "Run this script as your desktop user, without sudo." >&2
  exit 1
fi

applications="$HOME/Applications"
appimage="$applications/VSCodium.AppImage"
if ! "$extensions_only"; then
  for command in curl jq; do
    command -v "$command" >/dev/null || {
      echo "Missing dependency: $command (install with sudo apt-get install curl jq)." >&2
      exit 1
    }
  done
  case "$(uname -m)" in
    x86_64) arch=x86_64 ;;
    aarch64|arm64) arch=aarch64 ;;
    *) echo "Unsupported AppImage architecture: $(uname -m)" >&2; exit 1 ;;
  esac
  mkdir -p "$applications"
  workdir=$(mktemp -d "$applications/.vscodium-update.XXXXXXXX")
  trap 'rm -rf -- "$workdir"' EXIT
  curl --fail --silent --show-error --location --retry 3 \
    https://api.github.com/repos/VSCodium/vscodium/releases/latest \
    -o "$workdir/release.json"
  asset=$(jq -cer --arg suffix "-${arch}.AppImage" \
    '[.assets[] | select(.name | endswith($suffix))] |
     if length == 1 then .[0] else error("No unique AppImage for this architecture") end' \
    "$workdir/release.json")
  filename=$(jq -r '.name' <<< "$asset")
  target="$applications/$filename"
  if [[ ! -f $target ]]; then
    echo "Downloading $filename..."
    curl --fail --show-error --location --retry 3 \
      "$(jq -r '.browser_download_url' <<< "$asset")" -o "$workdir/$filename"
    digest=$(jq -r '.digest // empty' <<< "$asset")
    if [[ $digest == sha256:* ]]; then
      printf '%s  %s\n' "${digest#sha256:}" "$workdir/$filename" | sha256sum --check --status
    fi
    chmod +x "$workdir/$filename"
    mv -- "$workdir/$filename" "$target"
  else
    echo "$filename is already downloaded."
    chmod +x "$target"
  fi
  # A stable launcher path; keep previous versioned AppImages available.
  if [[ -e $appimage && ! -L $appimage ]]; then
    echo "$appimage exists and is not a symlink; refusing to replace it." >&2
    exit 1
  fi
  ln -sfn -- "$filename" "$appimage"
elif [[ ! -x $appimage ]]; then
  echo "Run ${0##*/} without --extensions-only once to install the stable AppImage launcher." >&2
  exit 1
fi

# Install only the tools used by the automation repositories, rather than a
# broad extension pack. Cucumber includes Gherkin support; Selenium/Allure are
# project dependencies, not editor plugins. Existing extensions are left alone;
# VSCodium manages their updates according to the user's settings.
extensions=(
  redhat.java
  vscjava.vscode-java-debug
  vscjava.vscode-java-test
  vscjava.vscode-maven
  vscjava.vscode-java-dependency
  CucumberOpen.cucumber-official
  redhat.vscode-xml
  redhat.vscode-yaml
  ms-python.python
  ms-python.debugpy
  timonwong.shellcheck
  golang.Go
)
# Extraction mode also works without FUSE. Never launch as root or disable
# Electron's sandbox. Fail rather than treating a failed query as an empty list.
installed_extensions=$(APPIMAGE_EXTRACT_AND_RUN=1 "$appimage" --list-extensions)
declare -A installed_ids=()
while IFS= read -r extension; do
  [[ -z $extension ]] || installed_ids["${extension,,}"]=1
done <<< "$installed_extensions"

arguments=()
for extension in "${extensions[@]}"; do
  if [[ -n ${installed_ids[${extension,,}]:-} ]]; then
    echo "Already installed: $extension"
  else
    arguments+=(--install-extension "$extension")
  fi
done
if (( ${#arguments[@]} )); then
  echo "Installing missing development extensions from Open VSX..."
  APPIMAGE_EXTRACT_AND_RUN=1 "$appimage" "${arguments[@]}"
else
  echo "All development extensions are already installed."
fi
echo "VSCodium and development extensions are ready: $appimage"
echo "Java projects also require a suitable JDK and Maven (WebClient currently targets Java 25)."

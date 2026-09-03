#!/usr/bin/env bash
set -euo pipefail

# Build/update GNU IceCat from the official GNUzilla recipes.
# GNUzilla transforms a verified Firefox ESR source tarball into IceCat sources;
# the resulting browser is then built locally with Mozilla's mach frontend.

if [[ -z ${su+x} ]]; then
  su=sudo
fi

GNUZILLA_REPO=${GNUZILLA_REPO:-https://git.savannah.gnu.org/git/gnuzilla.git}
GNUZILLA_DIR=${GNUZILLA_DIR:-$HOME/src/gnuzilla}
ICECAT_LINK=${ICECAT_LINK:-$HOME/src/icecat}
ICECAT_BIN_DIR=${ICECAT_BIN_DIR:-$HOME/bin}
ICECAT_JOBS=${ICECAT_JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || printf '1')}
ICECAT_MIN_FREE_GIB=${ICECAT_MIN_FREE_GIB:-45}

source_only=false
force=false
install_deps=true

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Options:
  --source-only  Generate/update IceCat sources, but do not compile them
  --force        Regenerate and rebuild even when GNUzilla did not change
  --no-deps      Do not run apt-get; use the dependencies already installed
  -h, --help     Show this help

Environment overrides:
  GNUZILLA_DIR, ICECAT_LINK, ICECAT_BIN_DIR, ICECAT_JOBS,
  ICECAT_MIN_FREE_GIB, GNUZILLA_REPO, su
EOF
}

while (($#)); do
  case $1 in
    --source-only) source_only=true ;;
    --force) force=true ;;
    --no-deps) install_deps=false ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ $GNUZILLA_DIR == "$ICECAT_LINK" ]]; then
  printf 'GNUZILLA_DIR and ICECAT_LINK must be different paths.\n' >&2
  exit 1
fi

mkdir -p "$HOME/src" "$ICECAT_BIN_DIR"

free_kib=$(df -Pk "$HOME/src" | awk 'NR == 2 { print $4 }')
required_kib=$((ICECAT_MIN_FREE_GIB * 1024 * 1024))
if ((free_kib < required_kib)); then
  printf 'Not enough free space: IceCat needs at least %s GiB; %s GiB are available.\n' \
    "$ICECAT_MIN_FREE_GIB" "$((free_kib / 1024 / 1024))" >&2
  exit 1
fi

if [[ $install_deps == true ]]; then
  printf '>> Installing IceCat build dependencies...\n'
  $su apt-get update
  $su apt-get install -y \
    autoconf \
    bash \
    build-essential \
    bzip2 \
    ca-certificates \
    cargo \
    cbindgen \
    clang \
    curl \
    git \
    gnupg \
    libasound2-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libdbus-glib-1-dev \
    libdrm-dev \
    libevent-dev \
    libffi-dev \
    libgtk-3-dev \
    libhunspell-dev \
    libicu-dev \
    libjpeg-dev \
    liblz4-dev \
    libnotify-dev \
    libnspr4-dev \
    libnss3-dev \
    libpci-dev \
    libpng-dev \
    libpulse-dev \
    libsqlite3-dev \
    libstartup-notification0-dev \
    libvpx-dev \
    libx11-xcb-dev \
    libxss-dev \
    libxt-dev \
    libzstd-dev \
    lld \
    llvm \
    m4 \
    make \
    nasm \
    ninja-build \
    nodejs \
    patch \
    perl \
    pkg-config \
    python3 \
    python3-dev \
    python3-jsonschema \
    python3-venv \
    rustc \
    unzip \
    uuid-dev \
    wget \
    xz-utils \
    yasm \
    zip \
    zlib1g-dev
fi

if [[ ! -d $GNUZILLA_DIR/.git ]]; then
  if [[ -e $GNUZILLA_DIR ]]; then
    printf '%s exists but is not a Git checkout; refusing to overwrite it.\n' "$GNUZILLA_DIR" >&2
    exit 1
  fi
  printf '>> Cloning GNUzilla into %s...\n' "$GNUZILLA_DIR"
  git clone "$GNUZILLA_REPO" "$GNUZILLA_DIR"
else
  printf '>> Updating GNUzilla in %s...\n' "$GNUZILLA_DIR"
  git -C "$GNUZILLA_DIR" fetch --tags origin
  git -C "$GNUZILLA_DIR" pull --ff-only
fi

current_commit=$(git -C "$GNUZILLA_DIR" rev-parse HEAD)
generated_state=$GNUZILLA_DIR/.last-generated-commit
built_state=$GNUZILLA_DIR/.last-built-commit
generated_commit=
built_commit=
[[ ! -f $generated_state ]] || generated_commit=$(<"$generated_state")
[[ ! -f $built_state ]] || built_commit=$(<"$built_state")

ff_major=$(sed -n 's/^readonly FFMAJOR=//p' "$GNUZILLA_DIR/makeicecat")
ff_minor=$(sed -n 's/^readonly FFMINOR=//p' "$GNUZILLA_DIR/makeicecat")
ff_sub=$(sed -n 's/^readonly FFSUB=//p' "$GNUZILLA_DIR/makeicecat")
icecat_version=$ff_major.$ff_minor.$ff_sub
icecat_source=$GNUZILLA_DIR/output/icecat-$icecat_version

if [[ $force == true || $generated_commit != "$current_commit" || ! -d $icecat_source ]]; then
  printf '>> Generating IceCat %s sources from verified Firefox ESR sources...\n' "$icecat_version"
  (
    cd "$GNUZILLA_DIR"
    ./makeicecat
  )
  printf '%s\n' "$current_commit" > "$generated_state"
else
  printf '>> IceCat %s sources are already current.\n' "$icecat_version"
fi

if [[ -L $ICECAT_LINK ]]; then
  ln -sfn "$icecat_source" "$ICECAT_LINK"
elif [[ -e $ICECAT_LINK ]]; then
  printf '%s already exists and is not a symlink; refusing to overwrite it.\n' "$ICECAT_LINK" >&2
  exit 1
else
  ln -s "$icecat_source" "$ICECAT_LINK"
fi

if [[ $source_only == true ]]; then
  printf '\nIceCat %s sources are ready at %s\n' "$icecat_version" "$ICECAT_LINK"
  exit 0
fi

icecat_binary=$ICECAT_LINK/obj-icecat/dist/bin/icecat
if [[ $force == false && $built_commit == "$current_commit" && -x $icecat_binary ]]; then
  printf '>> IceCat %s is already built; nothing to do.\n' "$icecat_version"
else
  printf '>> Building IceCat %s with %s parallel jobs...\n' "$icecat_version" "$ICECAT_JOBS"
  cat > "$ICECAT_LINK/.mozconfig" <<EOF
ac_add_options --with-l10n-base=$ICECAT_LINK/l10n
ac_add_options --enable-official-branding
ac_add_options --with-distribution-id=org.gnu
ac_add_options --enable-release
ac_add_options --with-unsigned-addon-scopes=app,system
ac_add_options --allow-addon-sideload
ac_add_options --disable-debug
ac_add_options --disable-tests
ac_add_options --disable-updater
ac_add_options --disable-crashreporter
ac_add_options --disable-eme
ac_add_options --without-wasm-sandboxed-libraries
ac_add_options --enable-application=browser
mk_add_options MOZ_OBJDIR=$ICECAT_LINK/obj-icecat
mk_add_options MOZ_MAKE_FLAGS=-j$ICECAT_JOBS
EOF
  (
    cd "$ICECAT_LINK"
    ./mach build
    ./mach package
  )
  printf '%s\n' "$current_commit" > "$built_state"
fi

if [[ ! -x $icecat_binary ]]; then
  printf 'Build completed but the IceCat executable was not found at %s\n' "$icecat_binary" >&2
  exit 1
fi

cat > "$ICECAT_BIN_DIR/icecat" <<EOF
#!/bin/sh
exec "$icecat_binary" "\$@"
EOF
chmod +x "$ICECAT_BIN_DIR/icecat"

package=$(find "$ICECAT_LINK/obj-icecat/dist" -maxdepth 1 -type f \
  \( -name 'icecat-*.tar.*' -o -name 'icecat-*.tar.bz2' \) -print 2>/dev/null | sort -V | tail -n 1)

printf '\nGNU IceCat %s is ready.\n' "$icecat_version"
printf 'Source:   %s\n' "$ICECAT_LINK"
printf 'Binary:   %s\n' "$ICECAT_BIN_DIR/icecat"
[[ -z $package ]] || printf 'Package:  %s\n' "$package"

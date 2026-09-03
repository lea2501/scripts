#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

cd || return
$su apt-get -y --fix-missing install jq
$su apt-get -y --fix-missing --no-install-recommends install nodejs node-corepack cmake
$su apt-get -y --fix-missing install node-opencv

# Preparar pnpm mediante Corepack sin instalar el paquete npm de Debian.
PNPM_VERSION="10.34.0"
COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack "pnpm@$PNPM_VERSION" --version >/dev/null

# Mantener Appium y sus dependencias aislados del sistema y del directorio home.
APPIUM_DIR="$HOME/.local/share/appium"
mkdir -p "$APPIUM_DIR" "$HOME/bin"
corepack "pnpm@$PNPM_VERSION" --dir "$APPIUM_DIR" add appium wd

# El launcher que genera pnpm en node_modules/.bin/appium resuelve rutas
# relativas a $0. Un symlink POSIX no reescribe $0 al target real, por lo que
# basedir apuntaría a ~/bin y appium buscaría el modulo en ~/.pnpm (inexistente).
# Usamos un wrapper que invoca la ruta real por su path absoluto.
cat > "$HOME/bin/appium" <<EOF
#!/bin/sh
exec "$APPIUM_DIR/node_modules/.bin/appium" "\$@"
EOF
chmod +x "$HOME/bin/appium"

# 'appium driver install' delega en npm para resolver e instalar los drivers.
# Como usamos Corepack (no el paquete npm de Debian), proveemos un wrapper npm
# fijado a una version compatible con Node 20.
NPM_VERSION="10.9.2"
COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack "npm@$NPM_VERSION" --version >/dev/null
cat > "$HOME/bin/npm" <<EOF
#!/bin/sh
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
exec corepack "npm@$NPM_VERSION" "\$@"
EOF
chmod +x "$HOME/bin/npm"

export PATH="$HOME/bin:$PATH"

# Drivers segun el sistema operativo:
#   - Linux : solo Android (uiautomator2)
#   - macOS : Android (uiautomator2) + iOS (xcuitest)
appium driver list
appium driver install uiautomator2
case "$(uname -s)" in
  Darwin)
    appium driver install xcuitest
    ;;
esac

# appium-inspector (appium-desktop is deprecated and archived since 2023)
cd || return
mkdir -p ~/Applications
cd ~/Applications || return
case "$(uname -s)" in
  Darwin)
    # macOS: descargar el .dmg del arquitectura correspondiente (arm64/x86_64).
    case "$(uname -m)" in
      arm64) INSPECTOR_PATTERN="mac-arm64.dmg" ;;
      *)     INSPECTOR_PATTERN="mac-x64.dmg" ;;
    esac
    ;;
  *)
    # Linux: AppImage x86_64.
    INSPECTOR_PATTERN="linux-x86_64.AppImage"
    ;;
esac
curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-inspector/releases/latest | jq -r ".assets[] | select(.name | test(\"$INSPECTOR_PATTERN\")) | .browser_download_url")"
case "$(uname -s)" in
  Darwin) : ;;  # el .dmg se monta/instala manualmente
  *) chmod +x ./*.AppImage ;;
esac
cd - || return

#!/bin/bash
# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

SSH_DIR="$HOME/.ssh"
SSH_CONFIG="$SSH_DIR/config"
ALIASES_FILE="$HOME/.bash_aliases"
VPN_ALIAS="alias vpn-labo='cd ~ && echo [PASS] && sudo openvpn --config ~/FILE.ovpn'"
BLOCK_START="# BEGIN VPN GitLab SSH configuration"
BLOCK_END="# END VPN GitLab SSH configuration"

echo "=== Instalación de OpenVPN ==="
if command -v openvpn >/dev/null 2>&1; then
  echo "OpenVPN ya está instalado."
else
  echo "OpenVPN no está instalado; instalando mediante apt..."
  sudo apt-get update -qq
  sudo apt-get install -qq -y openvpn
fi
echo ""

echo "=== DNS para usar la VPN ==="
echo ""
echo "Si los navegadores no pueden resolver URLs con la VPN conectada,"
echo "configurá temporalmente los DNS de Google en /etc/resolv.conf:"
echo ""
echo "  nameserver 8.8.8.8"
echo "  nameserver 8.8.4.4"
echo ""
echo "Ejemplo para editarlo como root:"
echo "  sudo \${EDITOR:-vi} /etc/resolv.conf"
echo ""
echo "Nota: DHCP, NetworkManager o resolvconf pueden regenerar ese archivo."
echo "Si el cambio se pierde, configurá esos DNS en el gestor de red."
echo ""

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
touch "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"

if grep -Fq "$BLOCK_START" "$SSH_CONFIG"; then
  echo "La configuración SSH para GitLab mediante VPN ya existe en $SSH_CONFIG."
else
  cat >>"$SSH_CONFIG" <<'EOF'

# BEGIN VPN GitLab SSH configuration
Host *
    SetEnv TERM=xterm-256color

Host gitlab.com
    Hostname altssh.gitlab.com
    Port 443
    User git
# END VPN GitLab SSH configuration
EOF

  echo "Configuración SSH agregada a $SSH_CONFIG."
fi

echo ""
touch "$ALIASES_FILE"
if grep -Fqx "$VPN_ALIAS" "$ALIASES_FILE"; then
  echo "El alias vpn-labo ya existe en $ALIASES_FILE."
else
  printf '\n%s\n' "$VPN_ALIAS" >>"$ALIASES_FILE"
  echo "Alias vpn-labo agregado a $ALIASES_FILE."
fi

echo "Reemplazá FILE.ovpn en $ALIASES_FILE por el nombre real de tu perfil VPN."
echo "Para cargar el alias en la terminal actual:"
echo "  source ~/.bash_aliases"
echo ""
echo "Podés comprobar la conexión con:"
echo "  ssh -T git@gitlab.com"

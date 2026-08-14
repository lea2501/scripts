#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Setup de ~/.env con GITLAB_TOKEN y carga automática desde ~/.profile
# Solo configura GitLab. Para setup completo de Kiro (Jira, GitLab, Slack, MCPs):
#   ./setup_kiro_mcp.sh
#
# Uso: ./setup_gitlab_env.sh
#   Se pedirá el token interactivamente si no se pasa como argumento.
#   Opcionalmente: ./setup_gitlab_env.sh glpat-xxxxx

TOKEN="${1:-}"

if [ -z "$TOKEN" ]; then
  echo "Ingresá tu GitLab Personal Access Token (scope: read_api):"
  echo -n "  GITLAB_TOKEN: "
  read -r TOKEN
fi

if [ -z "$TOKEN" ]; then
  echo "ERROR: no se proporcionó un token."
  exit 1
fi

# --- Crear/actualizar ~/.env ---
ENV_FILE="$HOME/.env"

if [ -f "$ENV_FILE" ] && grep -q "^GITLAB_TOKEN=" "$ENV_FILE"; then
  # Reemplazar token existente
  sed -i "s|^GITLAB_TOKEN=.*|GITLAB_TOKEN=${TOKEN}|" "$ENV_FILE"
  echo "[OK] GITLAB_TOKEN actualizado en $ENV_FILE"
else
  echo "GITLAB_TOKEN=${TOKEN}" >>"$ENV_FILE"
  echo "[OK] GITLAB_TOKEN agregado a $ENV_FILE"
fi

chmod 600 "$ENV_FILE"

# --- Agregar source de ~/.env en ~/.profile si no existe ---
PROFILE_FILE="$HOME/.profile"

if [ -f "$PROFILE_FILE" ] && grep -q '\.env' "$PROFILE_FILE"; then
  echo "[OK] ~/.profile ya carga ~/.env"
else
  cat >>"$PROFILE_FILE" <<'EOF'

# Load environment tokens (~/.env)
if [ -f "$HOME/.env" ]; then
    set -a
    . "$HOME/.env"
    set +a
fi
EOF
  echo "[OK] Agregado source de ~/.env en ~/.profile"
fi

# --- Crear ~/bin si no existe ---
mkdir -p "$HOME/bin"

# --- Exportar para la sesión actual ---
export GITLAB_TOKEN="$TOKEN"

echo ""
echo "=== Setup completo ==="
echo "  - Token guardado en: ~/.env (permisos 600)"
echo "  - ~/.profile carga ~/.env automáticamente en cada login"
echo "  - ~/bin/ listo para recibir los binarios"
echo ""
echo "Para aplicar ahora sin reloguear:"
echo "  source ~/.profile"
echo ""
echo "Para descargar los Go tools:"
echo "  ~/repos/flow/automation-tools-flow/scripts/downloadGoTools.sh"

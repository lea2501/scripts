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
#   El token se pide interactivamente y sin eco. No se acepta como argumento,
#   para que no quede registrado en el historial ni visible en la lista de procesos.

echo "Ingresá tu GitLab Personal Access Token (scope: read_api):"
read -r -s -p "  GITLAB_TOKEN: " TOKEN
echo

if [ -z "$TOKEN" ]; then
  echo "ERROR: no se proporcionó un token."
  exit 1
fi

# --- Crear/actualizar ~/.env ---
ENV_FILE="$HOME/.env"

tmp_env=$(mktemp "${ENV_FILE}.XXXXXX")
trap 'rm -f "$tmp_env"' EXIT
[ ! -f "$ENV_FILE" ] || grep -v '^GITLAB_TOKEN=' "$ENV_FILE" >"$tmp_env"
printf 'GITLAB_TOKEN=%q\n' "$TOKEN" >>"$tmp_env"
mv "$tmp_env" "$ENV_FILE"
trap - EXIT
echo "[OK] GITLAB_TOKEN guardado en $ENV_FILE"

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

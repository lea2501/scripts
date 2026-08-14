#!/bin/bash

# fail if any commands fails
set -e

# =============================================================================
# Setup completo de Kiro CLI: MCPs (Jira, GitLab, Slack, chrome-devtools)
# Configura ~/.kiro/settings/mcp.json y los tokens en ~/.env
#
# Uso:
#   ./setup_kiro_mcp.sh              # Pide todos los tokens interactivamente
#   ./setup_kiro_mcp.sh --skip-existing  # Solo pide los que faltan
#
# Requiere: jq, npm (node), uv (para uvx)
# =============================================================================

SKIP_EXISTING=false
[ "${1:-}" = "--skip-existing" ] && SKIP_EXISTING=true

ENV_FILE="$HOME/.env"
MCP_FILE="$HOME/.kiro/settings/mcp.json"
PROFILE_FILE="$HOME/.profile"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; }

# =============================================================================
# 1. Verificar dependencias
# =============================================================================
echo ""
echo "=== Verificando dependencias ==="

check_dep() {
  if ! command -v "$1" &>/dev/null; then
    err "$1 no encontrado. Instalalo antes de continuar."
    echo "    $2"
    return 1
  fi
  ok "$1 encontrado"
}

check_dep "jq" "apt install jq / brew install jq" || exit 1
check_dep "npm" "apt install npm / instalar nvm" || exit 1
check_dep "uvx" "pip install uv / pipx install uv" || exit 1

# =============================================================================
# 2. Leer tokens existentes de ~/.env (si existen)
# =============================================================================
echo ""
echo "=== Configuración de tokens ==="

# Cargar variables existentes del .env si existe
if [ -f "$ENV_FILE" ]; then
  set -a
  . "$ENV_FILE"
  set +a
fi

# --- Función para pedir un token ---
ask_token() {
  local var_name="$1"
  local description="$2"
  local hint="$3"
  local current_value="${!var_name:-}"

  if [ -n "$current_value" ] && [ "$SKIP_EXISTING" = true ]; then
    ok "$var_name ya configurado (${current_value:0:12}...)"
    return 0
  fi

  if [ -n "$current_value" ]; then
    echo ""
    echo "  $description"
    echo "  Valor actual: ${current_value:0:12}..."
    echo -n "  Nuevo valor (Enter para mantener): "
    read -r new_value
    if [ -z "$new_value" ]; then
      ok "$var_name mantenido"
      return 0
    fi
    eval "$var_name='$new_value'"
  else
    echo ""
    echo "  $description"
    [ -n "$hint" ] && echo "  Hint: $hint"
    echo -n "  $var_name: "
    read -r new_value
    if [ -z "$new_value" ]; then
      warn "$var_name no configurado (se puede agregar después)"
      return 1
    fi
    eval "$var_name='$new_value'"
  fi
  return 0
}

# --- Pedir cada token ---
ask_token "GITLAB_TOKEN" \
  "GitLab Personal Access Token (scope: api o read_api)" \
  "Generalo en https://gitlab.com/-/user_settings/personal_access_tokens"
HAS_GITLAB=$?

ask_token "JIRA_API_TOKEN" \
  "Jira API Token (Atlassian Cloud)" \
  "Generalo en https://id.atlassian.com/manage-profile/security/api-tokens"
HAS_JIRA=$?

ask_token "JIRA_USERNAME" \
  "Jira Username (email de Atlassian)" \
  "Ejemplo: usuario@empresa.com"

ask_token "JIRA_URL" \
  "Jira URL base" \
  "Ejemplo: https://tuempresa.atlassian.net"
# Default si no se configuró
: "${JIRA_URL:=https://tecocloud.atlassian.net}"

ask_token "SLACK_MCP_XOXP_TOKEN" \
  "Slack User OAuth Token (xoxp-...)" \
  "Slack App > OAuth & Permissions > User OAuth Token"
HAS_SLACK=$?

# =============================================================================
# 3. Guardar tokens en ~/.env
# =============================================================================
echo ""
echo "=== Guardando tokens en ~/.env ==="

save_to_env() {
  local var_name="$1"
  local value="${!var_name:-}"
  [ -z "$value" ] && return

  if [ -f "$ENV_FILE" ] && grep -q "^${var_name}=" "$ENV_FILE"; then
    sed -i "s|^${var_name}=.*|${var_name}=${value}|" "$ENV_FILE"
  else
    echo "${var_name}=${value}" >>"$ENV_FILE"
  fi
}

touch "$ENV_FILE"
save_to_env "GITLAB_TOKEN"
save_to_env "JIRA_API_TOKEN"
save_to_env "JIRA_USERNAME"
save_to_env "JIRA_URL"
save_to_env "SLACK_MCP_XOXP_TOKEN"
chmod 600 "$ENV_FILE"
ok "Tokens guardados en $ENV_FILE (permisos 600)"

# =============================================================================
# 4. Configurar ~/.profile para cargar ~/.env automáticamente
# =============================================================================
if [ -f "$PROFILE_FILE" ] && grep -q '\.env' "$PROFILE_FILE"; then
  ok "~/.profile ya carga ~/.env"
else
  cat >>"$PROFILE_FILE" <<'EOF'

# Load environment tokens (~/.env)
if [ -f "$HOME/.env" ]; then
    set -a
    . "$HOME/.env"
    set +a
fi
EOF
  ok "Agregado source de ~/.env en ~/.profile"
fi

# =============================================================================
# 5. Generar ~/.kiro/settings/mcp.json
# =============================================================================
echo ""
echo "=== Generando $MCP_FILE ==="

mkdir -p "$(dirname "$MCP_FILE")"

# Construir el JSON con jq
JIRA_ENV=$(jq -n \
  --arg user "${JIRA_USERNAME:-}" \
  --arg token "${JIRA_API_TOKEN:-}" \
  --arg url "${JIRA_URL:-https://tecocloud.atlassian.net}" \
  '{JIRA_USERNAME: $user, JIRA_API_TOKEN: $token, JIRA_URL: $url}')

GITLAB_ENV=$(jq -n \
  --arg token "${GITLAB_TOKEN:-}" \
  '{GITLAB_PERSONAL_ACCESS_TOKEN: $token, GITLAB_API_URL: "https://gitlab.com/api/v4"}')

SLACK_ENV=$(jq -n \
  --arg token "${SLACK_MCP_XOXP_TOKEN:-}" \
  '{SLACK_MCP_XOXP_TOKEN: $token}')

# Generar mcp.json completo
jq -n \
  --argjson jira_env "$JIRA_ENV" \
  --argjson gitlab_env "$GITLAB_ENV" \
  --argjson slack_env "$SLACK_ENV" \
'{
  mcpServers: {
    "chrome-devtools": {
      command: "npx",
      args: ["-y", "chrome-devtools-mcp@latest"]
    },
    jira: {
      command: "uvx",
      args: ["mcp-atlassian"],
      env: $jira_env
    },
    gitlab: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-gitlab"],
      env: $gitlab_env
    },
    slack: {
      command: "npx",
      args: ["-y", "slack-mcp-server"],
      env: $slack_env
    },
    fetch: {
      command: "uvx",
      args: ["mcp-server-fetch"],
      env: {},
      disabled: true
    }
  }
}' >"$MCP_FILE"

ok "Generado $MCP_FILE"

# =============================================================================
# 6. Crear ~/bin si no existe
# =============================================================================
mkdir -p "$HOME/bin"

# =============================================================================
# 7. Exportar para la sesión actual
# =============================================================================
export GITLAB_TOKEN="${GITLAB_TOKEN:-}"
export JIRA_API_TOKEN="${JIRA_API_TOKEN:-}"
export JIRA_USERNAME="${JIRA_USERNAME:-}"
export JIRA_URL="${JIRA_URL:-}"
export SLACK_MCP_XOXP_TOKEN="${SLACK_MCP_XOXP_TOKEN:-}"

# =============================================================================
# Resumen
# =============================================================================
echo ""
echo "========================================="
echo "  Setup de Kiro MCP completado"
echo "========================================="
echo ""
echo "  MCPs configurados:"
echo "    ✓ chrome-devtools (inspección web)"
echo "    ✓ jira (mcp-atlassian via uvx)"
[ -n "${GITLAB_TOKEN:-}" ] && echo "    ✓ gitlab (@modelcontextprotocol/server-gitlab)" || echo "    ✗ gitlab (sin token)"
[ -n "${SLACK_MCP_XOXP_TOKEN:-}" ] && echo "    ✓ slack (slack-mcp-server)" || echo "    ✗ slack (sin token)"
echo "    - fetch (disabled)"
echo ""
echo "  Archivos:"
echo "    - Tokens: ~/.env (permisos 600)"
echo "    - MCP config: ~/.kiro/settings/mcp.json"
echo "    - Auto-load: ~/.profile (source ~/.env)"
echo ""
echo "  Para aplicar ahora sin reloguear:"
echo "    source ~/.profile"
echo ""
echo "  Para renovar un token específico:"
echo "    Editá ~/.env y volvé a ejecutar este script"
echo "    o ejecutá: $0 (te pregunta de nuevo)"
echo ""

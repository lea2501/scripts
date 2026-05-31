#!/bin/bash
set -e

# Install aider-chat via pipx
# Requires: pipx, python3

# Install pipx if not present
if ! command -v pipx &> /dev/null; then
  pip install --user pipx
fi

pipx install aider-chat
pipx runpip aider-chat install audioop-lts

# Create default config for ollama
cat > "$HOME/.aider.conf.yml" << 'EOF'
model: ollama/qwen3:8b
EOF

echo ""
echo "Done. aider installed. Default model: ollama/qwen3:8b"

#!/bin/bash
set -e

# Install ollama and download models to ~/ia/models
# Devuan (sysvinit): no service is created, run "ollama serve" manually

MODELS_DIR="$HOME/ia/models"

if [ -z "${su+x}" ]; then
  su="sudo"
fi

# Install binary
curl -fsSL https://ollama.com/install.sh | $su bash

# Start serve in background for model downloads
mkdir -p "$MODELS_DIR"
OLLAMA_MODELS="$MODELS_DIR" ollama serve &
OLLAMA_PID=$!
sleep 3

# Download models
MODELS=("qwen3:1.7b" "qwen3:4b" "qwen3:8b" "qwen3:14b")
for model in "${MODELS[@]}"; do
  echo ">> Pulling $model..."
  OLLAMA_MODELS="$MODELS_DIR" ollama pull "$model"
done

# Stop background serve
kill $OLLAMA_PID 2>/dev/null

echo ""
echo "Done. Usage: OLLAMA_MODELS=$MODELS_DIR ollama serve"

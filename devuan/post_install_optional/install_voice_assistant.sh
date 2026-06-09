#!/bin/bash
set -e

# Install local voice assistant: whisper.cpp (STT) + piper (TTS)
# Requires: ollama installed, working microphone

INSTALL_DIR="$HOME/ia/voice-assistant"
WHISPER_MODEL="base"
PIPER_VOICE="es_AR-daniela-high"

echo ">> Installing voice assistant to $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Dependencies
sudo apt-get install -y alsa-utils sox cmake g++ git wget

# --- whisper.cpp ---
echo ">> Building whisper.cpp..."
cd "$INSTALL_DIR"
if [ ! -d whisper.cpp ]; then
  git clone --depth 1 https://github.com/ggml-org/whisper.cpp.git
fi
cd whisper.cpp
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc) --target whisper-cli

echo ">> Downloading whisper model ($WHISPER_MODEL)..."
./models/download-ggml-model.sh "$WHISPER_MODEL"

# --- piper ---
echo ">> Installing piper TTS..."
cd "$INSTALL_DIR"
PIPER_VERSION="2023.11.14-2"
PIPER_URL="https://github.com/rhasspy/piper/releases/download/${PIPER_VERSION}/piper_linux_x86_64.tar.gz"
if [ ! -f piper/piper ]; then
  wget -q "$PIPER_URL" -O piper.tar.gz
  tar xf piper.tar.gz
  rm piper.tar.gz
fi

echo ">> Downloading piper voice ($PIPER_VOICE)..."
mkdir -p "$INSTALL_DIR/piper/voices"
VOICE_BASE="https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_AR/daniela/high"
wget -q -nc "$VOICE_BASE/es_AR-daniela-high.onnx" -O "$INSTALL_DIR/piper/voices/${PIPER_VOICE}.onnx" || true
wget -q -nc "$VOICE_BASE/es_AR-daniela-high.onnx.json" -O "$INSTALL_DIR/piper/voices/${PIPER_VOICE}.onnx.json" || true

# --- symlinks ---
mkdir -p "$HOME/bin"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ln -sf "$SCRIPT_DIR/voice-assistant.sh" "$HOME/bin/voice-assistant"
ln -sf "$SCRIPT_DIR/voice-assistant-continuous.sh" "$HOME/bin/voice-assistant-continuous"

echo ""
echo "Done. Usage:"
echo "  voice-assistant              # modo Enter"
echo "  voice-assistant-continuous   # modo detección de silencio"

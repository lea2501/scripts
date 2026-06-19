#!/usr/bin/env bash
set -euo pipefail

# Install/update OpenAI Whisper via whisper.cpp.
# Devuan/Debian's python3-whisper package is Graphite's database library, not STT.

if [ -z "${su+x}" ]; then
  su="sudo"
fi

INSTALL_DIR="${WHISPER_CPP_SRC:-$HOME/src/whisper.cpp}"
MODEL_DIR="${WHISPER_CPP_MODEL_DIR:-$HOME/.local/share/whisper.cpp/models}"
CONFIG_DIR="${WHISPER_CPP_CONFIG_DIR:-$HOME/.config/whisper.cpp}"
BIN_DIR="${WHISPER_CPP_BIN_DIR:-$HOME/bin}"
DEFAULT_MODEL="${WHISPER_CPP_DEFAULT_MODEL:-base}"

# Spanish needs multilingual models, which are the names without the ".en" suffix.
# English can use those too, but the ".en" models are smaller/faster for English.
# Override before running, for example:
#   WHISPER_CPP_MODELS="base base.en small small.en medium" ./update_whisper.cpp.sh
MODELS="${WHISPER_CPP_MODELS:-tiny tiny.en base base.en small small.en}"

echo ">> Installing whisper.cpp dependencies..."
$su apt-get update
$su apt-get install -y \
  ca-certificates \
  cmake \
  ffmpeg \
  g++ \
  git \
  make \
  pkg-config \
  wget

mkdir -p "$HOME/src" "$MODEL_DIR" "$CONFIG_DIR" "$BIN_DIR"

if [ ! -d "$INSTALL_DIR/.git" ]; then
  echo ">> Cloning whisper.cpp into $INSTALL_DIR..."
  git clone https://github.com/ggml-org/whisper.cpp.git "$INSTALL_DIR"
else
  echo ">> Updating whisper.cpp in $INSTALL_DIR..."
  git -C "$INSTALL_DIR" fetch --tags
  git -C "$INSTALL_DIR" pull --ff-only
fi

echo ">> Building whisper.cpp..."
cmake -S "$INSTALL_DIR" -B "$INSTALL_DIR/build" -DCMAKE_BUILD_TYPE=Release
cmake --build "$INSTALL_DIR/build" -j"$(nproc)" --target whisper-cli

echo ">> Downloading Spanish/multilingual and English models to $MODEL_DIR..."
for model in $MODELS; do
  target="$MODEL_DIR/ggml-$model.bin"
  if [ -f "$target" ]; then
    echo "   already present: $model"
    continue
  fi

  echo "   downloading: $model"
  (
    cd "$INSTALL_DIR"
    ./models/download-ggml-model.sh "$model" "$MODEL_DIR"
  )
done

cat > "$CONFIG_DIR/whisper.env" << EOF
WHISPER_CPP_SRC="$INSTALL_DIR"
WHISPER_CPP_MODEL_DIR="$MODEL_DIR"
WHISPER_CPP_DEFAULT_MODEL="$DEFAULT_MODEL"
EOF

cat > "$BIN_DIR/whisper-cpp" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="$HOME/.config/whisper.cpp/whisper.env"
ENV_WHISPER_CPP_SRC="${WHISPER_CPP_SRC:-}"
if [ -f "$CONFIG_FILE" ]; then
  # shellcheck disable=SC1090
  . "$CONFIG_FILE"
fi

WHISPER_CPP_SRC="${WHISPER_CPP_SRC:-$HOME/src/whisper.cpp}"
WHISPER_CPP_SRC="${ENV_WHISPER_CPP_SRC:-$WHISPER_CPP_SRC}"
WHISPER_CLI="$WHISPER_CPP_SRC/build/bin/whisper-cli"

if [ ! -x "$WHISPER_CLI" ]; then
  WHISPER_CLI="$(find "$WHISPER_CPP_SRC/build" -type f -name whisper-cli -perm -111 | head -n 1)"
fi

if [ -z "$WHISPER_CLI" ] || [ ! -x "$WHISPER_CLI" ]; then
  echo "whisper-cli not found. Run update_whisper.cpp.sh again." >&2
  exit 1
fi

exec "$WHISPER_CLI" "$@"
EOF

cat > "$BIN_DIR/whisper-transcribe" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="$HOME/.config/whisper.cpp/whisper.env"
ENV_WHISPER_CPP_SRC="${WHISPER_CPP_SRC:-}"
ENV_WHISPER_CPP_MODEL_DIR="${WHISPER_CPP_MODEL_DIR:-}"
ENV_WHISPER_CPP_DEFAULT_MODEL="${WHISPER_CPP_DEFAULT_MODEL:-}"
if [ -f "$CONFIG_FILE" ]; then
  # shellcheck disable=SC1090
  . "$CONFIG_FILE"
fi

WHISPER_CPP_SRC="${WHISPER_CPP_SRC:-$HOME/src/whisper.cpp}"
WHISPER_CPP_MODEL_DIR="${WHISPER_CPP_MODEL_DIR:-$HOME/.local/share/whisper.cpp/models}"
WHISPER_CPP_DEFAULT_MODEL="${WHISPER_CPP_DEFAULT_MODEL:-base}"
WHISPER_CPP_SRC="${ENV_WHISPER_CPP_SRC:-$WHISPER_CPP_SRC}"
WHISPER_CPP_MODEL_DIR="${ENV_WHISPER_CPP_MODEL_DIR:-$WHISPER_CPP_MODEL_DIR}"
WHISPER_CPP_DEFAULT_MODEL="${ENV_WHISPER_CPP_DEFAULT_MODEL:-$WHISPER_CPP_DEFAULT_MODEL}"
WHISPER_CLI="$WHISPER_CPP_SRC/build/bin/whisper-cli"

if [ "$#" -lt 1 ]; then
  echo "Usage: whisper-transcribe AUDIO_FILE [whisper-cli args...]"
  echo "Example: whisper-transcribe audio.mp3 -l es -otxt"
  exit 1
fi

if [ ! -x "$WHISPER_CLI" ]; then
  WHISPER_CLI="$(find "$WHISPER_CPP_SRC/build" -type f -name whisper-cli -perm -111 | head -n 1)"
fi

if [ -z "$WHISPER_CLI" ] || [ ! -x "$WHISPER_CLI" ]; then
  echo "whisper-cli not found. Run update_whisper.cpp.sh again." >&2
  exit 1
fi

AUDIO_FILE="$1"
shift
MODEL_FILE="$WHISPER_CPP_MODEL_DIR/ggml-$WHISPER_CPP_DEFAULT_MODEL.bin"

exec "$WHISPER_CLI" \
  -m "$MODEL_FILE" \
  -f "$AUDIO_FILE" \
  "$@"
EOF

chmod +x "$BIN_DIR/whisper-cpp" "$BIN_DIR/whisper-transcribe"

echo ""
echo "Done. whisper.cpp installed."
echo "Config: $CONFIG_DIR/whisper.env"
echo "Models: $MODEL_DIR"
echo ""
echo "Usage:"
echo "  whisper-transcribe audio.mp3 -l es -otxt"
echo "  whisper-cpp -m $MODEL_DIR/ggml-$DEFAULT_MODEL.bin -f audio.wav -l auto"

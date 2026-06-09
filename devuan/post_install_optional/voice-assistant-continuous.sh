#!/bin/bash
# Voice assistant: continuous listening with silence detection (sox)

INSTALL_DIR="$HOME/ia/voice-assistant"
WHISPER="$INSTALL_DIR/whisper.cpp/build/bin/whisper-cli"
WHISPER_MODEL="$INSTALL_DIR/whisper.cpp/models/ggml-base.bin"
PIPER="$INSTALL_DIR/piper/piper"
PIPER_VOICE="$INSTALL_DIR/piper/voices/es_MX-claude-high.onnx"
OLLAMA_MODEL="${OLLAMA_MODEL:-qwen3:8b}"
TMPWAV="/tmp/voice_input.wav"

SYSTEM_PROMPT="Responde de forma concisa y natural en español. Máximo 2-3 oraciones."

echo "=== Asistente de voz local (modo continuo) ==="
echo "Modelo: $OLLAMA_MODEL"
echo "Hablá cuando quieras, corta con silencio. Ctrl+C para salir"
echo ""

while true; do
  echo ">> Esperando voz..."

  # Record: starts on voice (above 1% threshold), stops after 2s silence (below 3%)
  rec -q -r 16000 -c 1 -b 16 "$TMPWAV" silence 1 0.1 1% 1 2.0 3% 2>/dev/null

  echo "   Transcribiendo..."
  TEXT=$("$WHISPER" -m "$WHISPER_MODEL" -f "$TMPWAV" -l es --no-timestamps -nt 2>/dev/null | sed '/^$/d')

  if [ -z "$TEXT" ]; then
    continue
  fi
  echo "   Vos: $TEXT"

  echo "   Pensando..."
  RESPONSE=$(ollama run "$OLLAMA_MODEL" "$SYSTEM_PROMPT. Pregunta: $TEXT" 2>/dev/null | sed 's/<[^>]*>//g')
  echo "   IA: $RESPONSE"

  echo "$RESPONSE" | "$PIPER" --model "$PIPER_VOICE" --output_raw 2>/dev/null | aplay -q -r 22050 -f S16_LE -c 1 2>/dev/null
  echo ""
done

#!/bin/bash
# Voice assistant: press Enter to record, then transcribe -> LLM -> speak

INSTALL_DIR="$HOME/ia/voice-assistant"
WHISPER="$INSTALL_DIR/whisper.cpp/build/bin/whisper-cli"
WHISPER_MODEL="$INSTALL_DIR/whisper.cpp/models/ggml-base.bin"
PIPER="$INSTALL_DIR/piper/piper"
PIPER_VOICE="$INSTALL_DIR/piper/voices/es_AR-daniela-high.onnx"
OLLAMA_MODEL="${OLLAMA_MODEL:-qwen3:8b}"
RECORD_SECONDS="${RECORD_SECONDS:-5}"
TMPWAV="/tmp/voice_input.wav"

SYSTEM_PROMPT="Responde de forma concisa y natural en español. Máximo 2-3 oraciones."

echo "=== Asistente de voz local (modo Enter) ==="
echo "Modelo: $OLLAMA_MODEL | Grabación: ${RECORD_SECONDS}s"
echo "Presioná Enter para hablar, Ctrl+C para salir"
echo ""

while true; do
  read -r -p ">> [Enter para grabar] "

  echo "   Escuchando (${RECORD_SECONDS}s)..."
  rec -q -r 16000 -c 1 -b 16 "$TMPWAV" trim 0 "$RECORD_SECONDS" 2>/dev/null

  echo "   Transcribiendo..."
  TEXT=$("$WHISPER" -m "$WHISPER_MODEL" -f "$TMPWAV" -l es --no-timestamps -nt 2>/dev/null | sed '/^$/d')

  if [ -z "$TEXT" ]; then
    echo "   (no se detectó habla)"
    continue
  fi
  echo "   Vos: $TEXT"

  echo "   Pensando..."
  RESPONSE=$(ollama run "$OLLAMA_MODEL" "$SYSTEM_PROMPT. Pregunta: $TEXT" 2>/dev/null | sed ':a;N;$!ba;s/<think>.*<\/think>//g' | sed '/^$/d')
  echo "   IA: $RESPONSE"

  echo "$RESPONSE" | "$PIPER" --model "$PIPER_VOICE" --output_raw 2>/dev/null | aplay -q -r 22050 -f S16_LE -c 1 2>/dev/null
  echo ""
done

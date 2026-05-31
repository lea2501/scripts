#!/bin/bash
set -e

# quicktype: Generate JSON Schema from JSON, and types for many languages
# https://github.com/glideapps/quicktype
# Replaces deprecated schema-guru

npm install -g quicktype

echo ""
echo "Usage examples:"
echo "  quicktype --lang schema --src input.json -o schema.json"
echo "  quicktype --lang java --src input.json -o MyTypes.java"
echo "  cat input.json | quicktype --lang schema"

#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

# quicktype: Generate JSON Schema from JSON, and types for many languages
# https://github.com/glideapps/quicktype
# Replaces deprecated schema-guru

$su apt-get -y --fix-missing install npm
$su npm install -g quicktype

echo ""
echo "Usage examples:"
echo "  quicktype --lang schema --src input.json -o schema.json"
echo "  quicktype --lang java --src input.json -o MyTypes.java"
echo "  cat input.json | quicktype --lang schema"

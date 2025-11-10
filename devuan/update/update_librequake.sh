#!/bin/bash

repo=lavenderdotpet/LibreQuake
cd || return
mkdir -p /tmp/librequake
cd /tmp/librequake || return
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/"$repo"/releases/latest | grep browser_download_url | grep "full.zip" | head -n 1 | cut -d '"' -f 4)
curl -OL "$DOWNLOAD_URL"
cd - || return

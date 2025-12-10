#!/bin/bash

# fail if any commands fails
set -e
# debug log                                                                                                       
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

# Ensure curl is installed
if ! command -v curl &>/dev/null; then
  $su apt-get update -qq
  $su apt-get install -qq -y curl
fi

$su mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \

$su gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
$su tee /etc/apt/sources.list.d/antigravity.list > /dev/null

$su apt update

$su apt install antigravity

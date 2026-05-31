#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Docker installation for Debian (not Devuan - use podman on Devuan)
# get.docker.com does not recognize Devuan's /etc/os-release

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get -y --fix-missing install ca-certificates curl gnupg

$su install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | $su gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$su chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  $su tee /etc/apt/sources.list.d/docker.list > /dev/null

$su apt-get update
$su apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

$su groupadd docker || true
$su usermod -aG docker "$USER" || true

docker --version
echo "Log out and back in for group changes to take effect."

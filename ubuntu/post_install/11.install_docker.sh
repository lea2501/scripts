#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

# Installation https://docs.docker.com/engine/install/ubuntu/

$su apt-get -y update
$su apt-get install ca-certificates curl gnupg lsb-release

$su mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $su gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | $su tee /etc/apt/sources.list.d/docker.list > /dev/null

$su apt-get -y update
$su apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
$su groupadd docker || true
$su gpasswd -a $USER docker || true

echo "NOTE: You need to restart user session to use docker without sudo"
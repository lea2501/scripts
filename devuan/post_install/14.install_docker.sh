#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su wget -qO- https://get.docker.com/ | sh

$su groupadd docker || true
$su gpasswd -a $USER docker || true

docker --version

#$su gpasswd -a ${USER} docker
#$su service docker restart
#newgrp docker

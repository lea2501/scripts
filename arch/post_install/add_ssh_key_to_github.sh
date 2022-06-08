#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

read -rp "Enter Github username: " username
read -rp "Enter Github password: " password

curl -u "${username}:${password}" --data "{\"title\": \"TITLE\", \"key\": \"$(cat ~/.ssh/id_rsa.pub)\"}" https://api.github.com/user/keys
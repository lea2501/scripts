#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

read -rp "Enter Github username: " username
read -rp "Enter Github token: " token
ssh_title=$(awk '{print $3}' < ~/.ssh/id_rsa.pub)

curl -u "${username}:${token}" --data "{\"title\": \"${ssh_title}\", \"key\": \"$(cat ~/.ssh/id_rsa.pub)\"}" https://api.github.com/user/keys
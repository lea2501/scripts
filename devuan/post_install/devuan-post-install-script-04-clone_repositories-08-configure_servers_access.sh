#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

confRemoteServerAccess() {
  server=$1
  echo "Configure access to ${server} server..."
  read -rp "Enter your username for server ${server}: " serverUsername
  echo -e "\033[33;5m If connected then type 'exit' and press enter to continue \033[0m"
  ssh -t "${serverUsername}"@"${server}"
  echo ""
  echo "Connected successfully to server ${server} as user ${serverUsername}"
  echo ""
  echo "Configure access to ${server} server... DONE"
}

copySshKeysToRemoteServer() {
  server=$1
  echo "Copy Ssh keys to ${server} server..."
  read -rp "Enter your username for server ${server}: " serverUsername
  ssh-copy-id -i ~/.ssh/id_rsa.pub "${serverUsername}"@"${server}"
  echo ""
  echo "Copy Ssh keys to ${server} server... DONE"
}

accessRemoteServer() {
  server=$1
  echo "Access ${server} server..."
  read -rp "Enter your username for server ${server}: " serverUsername
  echo -e "\033[33;5m If connected then type 'exit' and press enter to continue \033[0m"
  ssh -i ~/.ssh/id_rsa "${serverUsername}"@"${server}"
  echo ""
  echo "Connected successfully to server ${server} as user ${serverUsername}"
  echo ""
  echo "Access ${server} server... DONE"
}

echo "Configure remote server access..."
confRemoteServerAccess 10.200.172.73
confRemoteServerAccess 10.200.172.74
confRemoteServerAccess 10.200.172.75

copySshKeysToRemoteServer 10.200.172.73
copySshKeysToRemoteServer 10.200.172.74
copySshKeysToRemoteServer 10.200.172.75

accessRemoteServer 10.200.172.73
accessRemoteServer 10.200.172.74
accessRemoteServer 10.200.172.75
echo "Configure remote server access... DONE"
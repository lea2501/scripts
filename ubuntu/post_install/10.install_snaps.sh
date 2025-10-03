#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

snap install intellij-idea-community --classic
snap install pycharm-community --classic
snap install postman
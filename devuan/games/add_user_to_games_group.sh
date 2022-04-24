#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

gpasswd -a "$USER" games

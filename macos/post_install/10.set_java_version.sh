#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

export JAVA_HOME=$(/usr/libexec/java_home -v11)
echo "Setting JAVA HOME... DONE"
export PATH=$JAVA_HOME/bin:$PATH

#!/usr/bin/env bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set java version to JDK 11
export JAVA_HOME=$(/usr/libexec/java_home -v17)
export PATH=$JAVA_HOME/bin:$PATH
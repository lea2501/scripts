#!/usr/bin/env bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set java version to JDK 8
export JAVA_HOME=$(/usr/libexec/java_home -v1.8)
export PATH=$JAVA_HOME/bin:$PATH
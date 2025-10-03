#!/bin/bash
# fail if any commands fails
set -e
# debug log
set -x

# Install gradle
gradle_version=8.0
if [ ! -d "/opt/gradle/gradle-${gradle_version}" ]
then
    echo "Directory /opt/gradle/gradle-${gradle_version} DOES NOT exists."
    curl --head https://services.gradle.org/distributions/gradle-${gradle_version}-all.zip
    (cd /tmp && sudo curl -OL https://services.gradle.org/distributions/gradle-${gradle_version}-all.zip)
    sudo unzip -d /opt/gradle /tmp/gradle-${gradle_version}-all.zip
fi
export GRADLE_HOME=/opt/gradle/gradle-${gradle_version}
export PATH=${GRADLE_HOME}/bin:${PATH}

echo ""
echo "Optional steps:"
echo "  $ cd REPOSITORY"
echo "  $ gradle wrapper"
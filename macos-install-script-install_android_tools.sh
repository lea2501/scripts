#!/usr/bin/env bash
# Usage:
# $ export ENVIRONMENT=staging && ./appAndroidCompileApk.sh

# Set java version to JDK 8
#export JAVA_HOME=$(/usr/libexec/java_home -v1.8)
#export PATH=$JAVA_HOME/bin:$PATH

# Install Android SDK packages
brew install -q android-sdk
brew install -q android-platform-tools
brew install -q android-studio
brew install -q android-file-transfer
#brew install -q android-ndk
brew install -q scrcpy
touch ~/.android/repositories.cfg
sdkmanager --update
sdkmanager "platform-tools" "platforms;android-30"
sdkmanager "build-tools;30.0.2"
#echo y | sdkmanager --licenses
yes | sdkmanager --licenses

# Set java version to JDK 11
export JAVA_HOME=$(/usr/libexec/java_home -v11)
export PATH=$JAVA_HOME/bin:$PATH

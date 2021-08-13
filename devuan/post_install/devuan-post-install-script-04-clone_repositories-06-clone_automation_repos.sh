#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Creating ~/repos directory..."
mkdir -p ~/repos
echo "Creating ~/repos directory... DONE"
echo "Cloning automation repos..."
cd ~/repos || return
git clone -b develop git@10.200.172.71:Automation/automation-wiki.git
git clone -b develop git@10.200.172.71:Automation/automation-tools.git
git clone -b develop git@10.200.172.71:Automation/automation-minerva.git
git clone -b develop git@10.200.172.71:Automation/automation-gateway.git
git clone -b develop git@10.200.172.71:Automation/automation-webclient.git
git clone -b develop git@10.200.172.71:Automation/automation-webclient-analytics.git
git clone -b develop git@10.200.172.71:Automation/automation-smarttv-ff.git
git clone -b develop git@10.200.172.71:Automation/automation-android.git
git clone -b develop git@10.200.172.71:Automation/automation-android-tv.git
git clone -b develop git@10.200.172.71:Automation/automation-ios.git
git clone -b develop git@10.200.172.71:Automation/automation-jmeter.git
git clone -b develop git@10.200.172.71:Automation/automation-wrk.git
git clone -b develop git@10.200.172.71:Automation/automation-api-iot.git
git clone -b develop git@10.200.172.71:Automation/automation-web-iot.git
git clone -b develop git@10.200.172.71:Automation/automation-android-iot.git
git clone -b develop git@10.200.172.71:Automation/automation-ios-iot.git
echo "Cloning automation repos... DONE"
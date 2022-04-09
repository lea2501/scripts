#!/bin/bash

mkdir -p ~/slackbuilds

cd ~/slackbuilds || exit
curl -OL "https://slackbuilds.org/slackbuilds/15.0/libraries/libconfig.tar.gz"
tar -xzvf libconfig.tar.gz
cd libconfig || exit
curl -OL "https://github.com/hyperrealm/libconfig/archive/v1.7.2/libconfig-1.7.2.tar.gz"
chmod +x libconfig.SlackBuild
./libconfig.SlackBuild

cd ~/slackbuilds || exit
curl -OL "https://slackbuilds.org/slackbuilds/15.0/system/sboui.tar.gz"
tar -xzvf sboui.tar.gz
cd sboui || exit
curl -OL "https://github.com/montagdude/sboui/archive/2.2/sboui-2.2.tar.gz"
chmod +x sboui.SlackBuild
./sboui.SlackBuild


#!/bin/bash

slackbuilds_dir=$HOME/slackbuilds
mkdir -p "$slackbuilds_dir"

cd "$slackbuilds_dir" || exit

# get dependencies
package=oniguruma
if [ ! -d "$slackbuilds_dir/$package" ]
then
  cd "$slackbuilds_dir" || exit
  curl -OL "https://slackbuilds.org/slackbuilds/14.2/development/oniguruma.tar.gz"
  tar -xzvf $package.tar.gz
  cd $package || exit
  curl -OL "https://github.com/kkos/oniguruma/releases/download/v5.9.6_p1/onig-5.9.6_p1.tar.gz"
  chmod +x $package.SlackBuild
  ./$package.SlackBuild
fi

package=jq
if [ ! -d "$slackbuilds_dir/$package" ]
then
  cd "$slackbuilds_dir" || exit
  curl -OL "https://slackbuilds.org/slackbuilds/14.2/system/jq.tar.gz"
  tar -xzvf $package.tar.gz
  cd $package || exit
  curl -OL "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz"
  chmod +x $package.SlackBuild
  ./$package.SlackBuild
fi

# get url from https://sbopkg.org/downloads.php
rm -rf sbopkg-*_wsr.tgz
curl -OL "$(curl -s https://api.github.com/repos/sbopkg/sbopkg/releases/latest | jq -r ".assets[] | select(.name | test(\"_wsr.tgz\")) | .browser_download_url" | head -n 1)"
installpkg sbopkg-*-noarch-1_wsr.tgz

# first run configuration
sbopkg

# sync
sbopkg -r
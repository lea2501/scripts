#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

application=jdownloader2
repository=https://aur.archlinux.org/jdownloader2.git
export compile=
mkdir -p ~/bin
cd ~/bin || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
  export compile=true
else
  cd $application || return
  #git pull
  pwd
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    pwd
    echo "Need to pull"
    git pull
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  ln -sf ~/bin/jdownloader2/JDownloader ~/bin/JDownloader
  ln -sf ~/bin/jdownloader2/JDownloader ~/bin/jdownloader
  ln -sf ~/bin/jdownloader2/JDownloaderHeadless ~/bin/JDownloaderHeadless
  ln -sf ~/bin/jdownloader2/JDownloaderHeadlessCtl ~/bin/JDownloaderHeadlessCtl
  ln -sf ~/bin/jdownloader2/JDownloaderHeadlessCleanLogin ~/bin/JDownloaderHeadlessCleanLogin
fi
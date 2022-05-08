#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

dir=$HOME/.config/badwolf
file=content-filters.json
url=https://easylist-downloads.adblockplus.org/easylist_min_content_blocker.json
mkdir -vp "$dir"
cd "$dir"
curl -o "$file" -L $url
ls -lahF "$dir"/$file

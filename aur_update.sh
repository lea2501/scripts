#!/bin/sh

# fail if any commands fails
#set -e
# debug log
#set -x

#for dir in ~/aur/*; do (cd "$dir" && pwd && git pull); done

for dir in ~/aur/*; do
  cd "$dir" || exit
  pwd
  CURRENT_DIR=$(basename "$PWD")
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    pwd
    echo "Need to pull"
    git pull
    makepkg -sic --noconfirm
  fi
  rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
done
exit 0

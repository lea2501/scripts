#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Cleaning temporary data... "
for dir in ~/aur/*
do
    cd "$dir" || exit
    CURRENT_DIR=$(basename "$PWD")
    rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
done
echo "Cleaning temporary data... DONE"
#/bin/bash

find . -depth -name '*[[:upper:]]*' -exec sh -c '
  for f do
    dir=${f%/*}
    name=${f##*/}
    newname=$(awk "BEGIN{print tolower(ARGV[1])}" "$name")
    mv -i -- "$f" "$dir/$newname"
  done' sh {} +

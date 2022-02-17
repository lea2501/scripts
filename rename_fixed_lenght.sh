#!/bin/sh

ext=$1
prefix=$2
for f in *.${ext}; do
    int=`basename $f .${ext} | cut -d '.' -f 2`
    new_name=`printf "${prefix}.%0.5i.${ext}\n" $int`
    [ ! -f $new_name ] && mv -v $f $new_name
done

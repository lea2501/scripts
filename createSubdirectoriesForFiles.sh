#/bin/bash
# This script will create a directory every 100 files and move files inside

i=0;
for f in *;
do
    d=dir_$(printf %06d $((i/1000+1)));
    mkdir -vp $d;
    mv "$f" $d;
    let i++;
done

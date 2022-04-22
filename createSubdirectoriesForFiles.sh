#/bin/bash
# This script will create a directory every 100 files and move files inside

i=0;
for f in *;
do
    d=dir_$(printf %03d $((i/100+1)));
    mkdir -p $d;
    mv "$f" $d;
    let i++;
done
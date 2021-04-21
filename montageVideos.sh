#/bin/bash
if [ -d .snapshots ]; then rm -Rf .snapshots; fi
mkdir -p .snapshots
for f in *.*; do input=$f; ffmpeg -ss $(bc -l <<< $(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration $input)*0.5) -i $input -frames:v 1 .snapshots/$input; done
montage -verbose -label %f -pointsize 10 -background '#000000' -fill 'gray' -define jpeg:size=300x300 -geometry 300x300+4+4 -auto-orient .snapshots/*.* output.png
rm -rf .snapshots

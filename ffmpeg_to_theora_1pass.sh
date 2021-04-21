#!/bin/bash

### set USAGE message
MESSAGE=$'USAGE: ffmpeg_to_webm <resolution> <minrate> <bitrate> <maxrate>\nExample: ffmpeg_to_webm 640:-1 500k 3000k 5500k'

# check and set parameters
if [ -z "$1" ]; then
	echo "$MESSAGE"
	exit 1
fi
if [ -z "$2" ]; then
	echo "$MESSAGE"
	exit 1
fi
if [ -z "$3" ]; then
	echo "$MESSAGE"
	exit 1
fi
if [ -z "$4" ]; then
	echo "$MESSAGE"
	exit 1
fi

# show entered parameters
echo Resolution: "$1"
RESOLUTION="$1"
echo Minrate: "$2"
MINRATE="$2"
echo Bitrate: "$3"
BITRATE="$3"
echo Maxrate: "$4"
maxRATE="$4"
echo Passes: 1pass encoding

# timeout confirmation
echo converting all files in $(pwd)
echo 10 seconds to cancel...
echo -----------------------
sleep 10s

# convert every file in dir
for FILE in *{.mp4,h264,mkv,avi}
do
	[ -e "$FILE" ] || continue
	echo "##########"
	echo Converting "$FILE" to MKV container :: -c:v libtheora :: -codec:a libvorbis
	echo "##########"
	
	#first pass
	#echo ffmpeg -i "$FILE" -map 0:0 -map 0:1 -map 0:4 -map 0:7 -map 0:8 -map 0:9 -map 0:10 -map 0:11 -map 0:12 -vf scale="$RESOLUTION" -c:v libtheora -minrate "$MINRATE" -b:v "$BITRATE" -maxrate "$MAXRATE" -codec:a libvorbis -b:a 128k "${FILE%.*}"_encode.mkv
	echo "Y" | ffmpeg -i "$FILE" -vf scale="$RESOLUTION" -c:v libtheora -minrate "$MINRATE" -b:v "$BITRATE" -maxrate "$MAXRATE" -codec:a libvorbis -b:a 128k "${FILE%.*}"_encode.mkv
	
	echo Conversion of "$FILE" successful!
	#Remove or comment out this line if you want to keep mp4 files
	#rm "$FILE";
done

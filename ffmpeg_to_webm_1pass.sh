#!/bin/bash

### set USAGE message
MESSAGE=$'USAGE: ffmpeg_to_webm <resolution> <constant rate factor (crf)>\nExample: ffmpeg_to_webm 640:-1 31'

# check and set parameters
if [ -z "$1" ]; then
	echo "$MESSAGE"
	exit 1
fi
if [ -z "$2" ]; then
	echo "$MESSAGE"
	exit 1
fi

# show entered parameters
echo Resolution: "$1"
RESOLUTION="$1"
echo Constant Rate Factor: "$2"
CRF="$2"
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
	echo Converting "$FILE" to WEBM container :: -c:v libvpx-vp9 :: -c:a libopus
	echo "##########"
	
	#first pass
	echo "Y" | ffmpeg -i "$FILE" -vf scale="$RESOLUTION" -c:v libvpx-vp9 -b:v 0 -crf "$CRF" -c:a libopus -b:a 64k -f webm "${FILE%.*}".webm
	
	echo Conversion of "$FILE" successful!
	#Remove or comment out this line if you want to keep mp4 files
	#rm "$FILE";
done

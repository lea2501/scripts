#!/bin/bash
# Author: Alon Ivtsan
# License: GPL3+

for FILE in *{.cbr,.CBR}
do
	[ -e "$FILE" ] || continue
	echo Converting $FILE to cbz format.
	DIR="${FILE%.*}"
	mkdir "$DIR";
	#unar ./"$FILE" -o "$DIR";
	7z x -o{"$DIR"} ./"$FILE";
	#TODO Delete Thumbnail files Thumbs.db
	zip -r "$DIR".cbz "$DIR";
	rm -r "$DIR";
	#Remove or comment out this line if you want to keep cbr files
	#rm "$FILE";
	echo Conversion of $FILE successful!
done

#!/bin/ksh
for f in $(ls *.cbr)
do
	# Set variables
	FILE="$f"
	DIR=$(echo "$FILE" | awk -F . '{print $1}')
	echo Extracting "$FILE" to "$DIR" ...
	# Create extract directory
	mkdir "$DIR"
	echo Created temporal directory "$DIR"
	# Extract file
	#7z x -o""$DIR"" ./""$FILE""
	unrar x -y "$FILE" "$DIR"
	echo Extracted "$FILE" to "$DIR"
	# Clean directory
	detox -rv "$DIR"
	find . -type f -name 'Thumbs.db' -exec rm {} +
	echo Cleaned temporal directory
	# Create cbz file
	zip -r "$DIR".cbz "$DIR"
	echo Created "$FILE".cbz file
	# Remove temporal directory
	rm -r "$DIR"
	echo Removed temporal directory "$DIR"
	#Remove this line if you want to remove cbr file
	#rm ""$FILE""
done

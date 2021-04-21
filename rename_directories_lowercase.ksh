#!/bin/ksh
for f in $(ls -p | grep /)
do
	#print "Full file path in $(pwd) dir : $f"
	#$(echo $f | tr '[A-Z]' '[a-z]')
	#echo $f | tr '[A-Z]' '[a-z]'
	#if [ -z "$f" ]; then
		FILE=$(echo $f | tr [A-Z] [a-z])
		#echo $FILE
		mv -v "$f" "$FILE"
	#fi
done

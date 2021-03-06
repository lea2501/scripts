#!/bin/ksh

dmenu_font="monospace:size=10"
col_black="#000000"
col_pink="#ff00f0"
col_violet="#8f00ff"
col_gray4="#eeeeee"
in=$(cat $HOME/Documentos/data/bookmarks | dmenu -m 0 -fn ${dmenu_font} -nb ${col_black} -nf ${col_pink} -sb ${col_violet} -sf ${col_gray4} -l 5 -p bookmarks:)     # dmenu input
match=$(cat $HOME/Documentos/data/bookmarks | grep $in | cut -d ',' -f 2)      # check match with ~/.bookmarks file
#in=$(cat $HOME/Documentos/data/bookmarks | dmenu -m 0 -fn ${dmenu_font} -nb ${col_black} -nf ${col_pink} -sb ${col_violet} -sf ${col_gray4} -l 5 -p bookmarks:)     # dmenu input
#match=$(cat $HOME/Documentos/data/bookmarks | grep $in)     # check match with ~/.bookmarks file

if [ "$match" != "" ]; then
  firefox-esr -P default-nojs "$match"
  #surf -bdfgIs -a @ -z 1 $match        # exec bookmark url
elif [ -n "$in" ]; then
  firefox-esr -P default-nojs "https://search.disroot.org/search?q=$in"     # search in searx
  #surf -bdfgIs -a @ -z 1 "https://search.disroot.org/search?q=$in"     # search in searx
fi

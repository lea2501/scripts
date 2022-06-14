#!/bin/sh

dmenu_font="monospace:size=10"
col_black="#000000"
col_pink="#ff00f0"
col_violet="#8f00ff"
col_gray4="#eeeeee"
#in=$(cat $HOME/Documentos/data/bookmarks | cut -d ',' -f 2 | dmenu -m 0 -fn ${dmenu_font} -nb ${col_black} -nf ${col_pink} -sb ${col_violet} -sf ${col_gray4} -l 5 -p bookmarks:)     # dmenu input
in=$(cat $HOME/Documentos/data/bookmarks | dmenu -m 0 -fn ${dmenu_font} -nb ${col_black} -nf ${col_pink} -sb ${col_violet} -sf ${col_gray4} -l 10 -p bookmarks:)     # dmenu input
match=$(cat $HOME/Documentos/data/bookmarks | grep $in | cut -d ',' -f 2)      # check match with ~/.bookmarks file
#in=$(cat $HOME/Documentos/data/bookmarks | dmenu -m 0 -fn ${dmenu_font} -nb ${col_black} -nf ${col_pink} -sb ${col_violet} -sf ${col_gray4} -l 5 -p bookmarks:)     # dmenu input
#match=$(cat $HOME/Documentos/data/bookmarks | grep $in)     # check match with ~/.bookmarks file

if [ "$match" != "" ]; then
  surf -bdfgIS -a @ -z 1 >/dev/null 2>&1 $match        # exec bookmark url
  #badwolf $match >/dev/null 2>&1    # exec bookmark url
  #qutebrowser $match                # exec bookmark url
elif [ -n "$in" ]; then
  surf -bdfgIS -a @ -z 1 "https://search.disroot.org/search?q=$in"    # search in searx
  #badwolf "https://search.disroot.org/search?q=$in" >/dev/null 2>&1    # search in searx
  #qutebrowser "https://search.disroot.org/search?q=$in"     # search in searx
fi

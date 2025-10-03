#!/bin/sh

dmenu_font="monospace:size=10"
col_black="#000000"
col_pink="#ff00f0"
col_violet="#8f00ff"
col_gray4="#eeeeee"
grep -hR "" $HOME/src/guides/*/* > /tmp/file
file=/tmp/file
in=$(cat $file | dmenu -m 0 -fn ${dmenu_font} -nb ${col_black} -nf ${col_pink} -sb ${col_violet} -sf ${col_gray4} -l 10 -p guides:)     # dmenu input
match=$(cat $file | grep "$in" | sed 's/\$ //g')      # check match with ~/.bookmarks file
rm /tmp/file

if [ "$match" != "" ]; then
  echo -n "$match" | xclip -selection clipboard
fi

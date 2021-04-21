WINEDEBUG=fps WINEPREFIX=$1 wine $2 2>&1 | tee /dev/stderr | sed -u -n -e '/trace/ s/.*approx //p' | osd_cat --lines=1 --color=yellow --outline=1 --pos=top  --align=center

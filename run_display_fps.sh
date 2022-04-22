LIBGL_SHOW_FPS=1 $1 2>&1 | tee /dev/stderr | sed -u -n -e '/^libGL: FPS = /{s/.* \([^ ]*\)= /\1/;p}' | osd_cat --lines=1 --color=yellow --outline=1 --pos=top --align=left

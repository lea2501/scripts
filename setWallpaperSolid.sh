#/bin/bash

#8f00ff

convert xc:"$1" /tmp/image.png
feh --bg-scale /tmp/image.png &

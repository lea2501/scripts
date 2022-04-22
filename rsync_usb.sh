#!/bin/sh
# rsync from usb script

### set usb name
DEV="D579-3A4D"
USB="$DEV"
USR=$(whoami)
### set directories
SYS=$(cat /etc/issue)
echo SYSTEM: $SYS
#if [[ $SYS == *"Debian"* ]]; then
#  echo "It's there!"
#fi
case "$SYS" in 
  *Debian*)
    DIR="/media/$USR/"
    ;;
  *Ubuntu*)
    DIR="/media/$USR/"
    ;;
  *Arch*)
    DIR="/run/media/$USR/"
    ;;
  *Antergos*)
    DIR="/run/media/$USR/"
    ;;
esac
### set USAGE message
MESSAGE="USAGE: rsync_usb <from/to> <dry/run>"

# go to home dir
cd ~

# check parameters
if [ -z "$1" ]; then
	echo $MESSAGE
	exit 1
fi
if [ -z "$2" ]; then
	echo $MESSAGE
	exit 1
fi

# set source/target
if [ "$1" = "from" ]; then
	SOURCE="$DIR""$DEV"/backup/
	TARGET=~/
else
	if [ "$1" = "to" ]; then
		SOURCE=~/
		TARGET="$DIR""$DEV"/backup/
	else
		echo $MESSAGE
		exit 1
	fi
fi
echo SOURCE: "$SOURCE"
echo TARGET: "$TARGET"

# dry run set
if [ "$2" = "dry" ]; then
	DRY_RUN="n"
	echo DRY_RUN: "YES"
else
	if [ "$2" = "run" ]; then
		DRY_RUN=""
		echo DRY_RUN: "NO"
	else
		echo $MESSAGE
		exit 1
	fi
fi

# timeout confirmation
#echo 10 seconds to cancel...
#echo -----------------------
#sleep 10s

### sync
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"Documentos "$TARGET" | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".Xresources "$TARGET".Xresources | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".bashrc "$TARGET".bashrc | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".bash_aliases "$TARGET".bash_aliases | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".bash_functions "$TARGET".bash_functions | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".xbindkeysrc "$TARGET".bash_functions | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".cwmrc "$TARGET".cwmrc | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".tmux.conf "$TARGET".tmux.conf | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".newsbeuter "$TARGET" | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".newsboat "$TARGET" | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"bin "$TARGET" | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i  --size-only "$SOURCE"Imágenes/ "$TARGET"Imágenes/ | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"books-epub "$TARGET" | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"books-pdf "$TARGET" | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"books-programming "$TARGET" | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"books-spiritual "$TARGET" | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".nethackrc "$TARGET".nethackrc | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".torcs "$TARGET" | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".speed-dreams-2 "$TARGET" | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".d1x-rebirth/ "$TARGET".d1x-rebirth/ | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".d2x-rebirth/ "$TARGET".d2x-rebirth/ | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".chocolate-doom "$TARGET" | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".crispy-doom "$TARGET" | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".config/gzdoom "$TARGET".config/ | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".prboom-plus "$TARGET" | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".quakespasm "$TARGET" | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".tyrquake/ "$TARGET".tyrquake/ | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE".yq2/ "$TARGET".yq2/ | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"Games/nethack "$TARGET"Games/ | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"Games/doom "$TARGET"Games/ | grep '^>' | awk '{ print $2 }'
rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"Games/quake "$TARGET"Games/ | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"Games/quake2 "$TARGET"Games/ | grep '^>' | awk '{ print $2 }'
#rsync -vhru"$DRY_RUN" -i --size-only "$SOURCE"Planes "$TARGET" | grep '^>' | awk '{ print $2 }'

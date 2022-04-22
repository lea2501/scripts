#!/bin/bash
# rsync script
# exit when any command fails
set -e

### set variables
username=$(echo "$USER")
### set directories
    DIR="/run/media/$username/"
### set USAGE message
MESSAGE="USAGE: rsync_usb <device_name> <dry/run>"

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

# set variables
DEVICE=$1

# set source/target
SOURCEDIR=~
TARGETDIR="$DIR$DEVICE/backup"
echo "SOURCE: $SOURCEDIR"
echo "TARGET: $TARGETDIR"

# dry run set
if [ "$2" = "dry" ]; then
	DRY_RUN=n
	echo "DRY_RUN: YES"
else
	if [ "$2" = "run" ]; then
		DRY_RUN=
		echo "DRY_RUN: NO"
	else
		echo $MESSAGE
		exit 1
	fi
fi

rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/Documentos" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.bash_aliases" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.tmux.conf" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/script" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.picom.conf" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.rtorrent.rc" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.vimrc" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.xinitrc" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.fehbg" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.bashrc" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.bash_profile" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/Documentacion" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.Xdefaults" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/.Xresources" "$TARGETDIR/backup/"
rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/books" "$TARGETDIR/"
#rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/games/doom" "$TARGETDIR/games/"
#rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/games/doom3" "$TARGETDIR/games/"
#rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/games/quake" "$TARGETDIR/games/"
#rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/games/quake2" "$TARGETDIR/games/"
#rsync -vhru"$DRY_RUN" --size-only --delete "$SOURCEDIR/games/wolf3d" "$TARGETDIR/games/"

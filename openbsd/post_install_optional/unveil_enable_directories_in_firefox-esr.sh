#!/bin/ksh

file=/etc/firefox-esr/unveil.content
if [ ! -f "$file" ]; then
  # Copy firefox default config files to /etc/firefox
  doas mkdir -p /etc/firefox-esr
  # Add directories to unveil.content
  {
    echo ""
    echo "# access to home directories"
    echo "~/unnamed/ rwc"
    echo "~/pictures/ rwc"
    echo "~/Documentos/ rwc"
    echo "~/Sync/ rwc"
    echo "~/games/ rwc"
    echo "~/isos/ rwc"
    echo "~/music/ rwc"
  } | doas tee -a "$file"
fi

file=/etc/firefox-esr/unveil.main
if [ ! -f "$file" ]; then
  # Copy firefox default config files to /etc/firefox
  doas mkdir -p /etc/firefox-esr
  # Add directories to unveil.main
  {
    echo ""
    echo "# access to home directories"
    echo "~/unnamed/ rwc"
    echo "~/pictures/ rwc"
    echo "~/Documentos/ rwc"
    echo "~/Sync/ rwc"
    echo "~/games/ rwc"
    echo "~/isos/ rwc"
    echo "~/music/ rwc"
  } | doas tee -a "$file"
fi

file=$HOME/.config/gtk-3.0/bookmarks
if [ ! -f "$file" ]; then
  username=$(echo $USER)
  {
    echo "file:///home/$username/unnamed"
    echo "file:///home/$username/pictures"
    echo "file:///home/$username/Documentos"
    echo "file:///home/$username/Sync"
    echo "file:///home/$username/games"
    echo "file:///home/$username/isos"
    echo "file:///home/$username/music"
    echo "file:///home/$username/videos"
  } >>$file
fi
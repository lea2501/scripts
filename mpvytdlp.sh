#!/bin/sh

content=$1
cd /tmp || return
yt-dlp --output yt-dlp_cache "$content"
mv yt-dlp_cache* yt-dlp_cache
ffmpeg -i yt-dlp_cache -vf scale=-2:480 -c:v libx264 -crf 0 -preset veryslow -c:a copy yt-dlp_cache-edit
mpv yt-dlp_cache-edit
rm -rf yt-dlp_cache*
cd - || return

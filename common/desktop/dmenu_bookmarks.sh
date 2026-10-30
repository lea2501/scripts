#!/bin/sh
# Portable bookmark launcher for Linux and OpenBSD (dmenu + Firefox).
set -eu

case "${1-}" in
    --unnamed) set -- "$HOME/Sync/bookmarks-unnamed" ;;
    --help|-h)
        printf '%s\n' 'Usage: bookmarks [FILE ...] | --unnamed' \
            'Default: ~/Sync/bookmarks and ~/Sync/bookmarks-work' \
            'Choose with dmenu; Enter opens Firefox, Escape cancels.'
        exit 0 ;;
    '') set -- "$HOME/Sync/bookmarks" "$HOME/Sync/bookmarks-work" ;;
esac

command -v dmenu >/dev/null 2>&1 || {
    echo 'bookmarks: dmenu is required.' >&2; exit 1;
}
if command -v firefox-esr >/dev/null 2>&1; then
    browser=firefox-esr
elif command -v firefox >/dev/null 2>&1; then
    browser=firefox
else
    echo 'bookmarks: Firefox was not found in PATH.' >&2; exit 1
fi
for file do
    if [ ! -r "$file" ]; then
        printf 'bookmarks: cannot read %s\n' "$file" >&2
        exit 1
    fi
done

# Display category and URL separated by a comma; preserve commas inside URLs.
selection=$(
    awk '
        { sub(/\r$/, "") }
        /^[[:space:]]*$/ { next }
        /^https?:\/\// { category="unnamed"; url=$0 }
        !/^https?:\/\// {
            comma=index($0, ",")
            if (!comma) next
            category=substr($0, 1, comma-1)
            url=substr($0, comma+1)
        }
        url ~ /^https?:\/\// {
            row=category "," url
            if (!seen[row]++) print row
        }
    ' "$@" | LC_ALL=C sort -f | dmenu -i -l 20 -p 'Bookmarks:'
) || exit 0
[ -n "$selection" ] || exit 0
url=$(printf '%s\n' "$selection" | awk '{ comma=index($0, ","); if (comma) print substr($0, comma+1) }')
case "$url" in
    http://*|https://*) ;;
    *) echo 'bookmarks: select a bookmark from the list.' >&2; exit 1 ;;
esac
"$browser" --new-tab "$url" >/dev/null 2>&1 &

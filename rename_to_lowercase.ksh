typeset -l f
for F in *[[:upper:]]*; do
  # [ -f "$f" ] || continue # uncomment to skip non-regular files if needed
  # [ -L "$f" ] && continue # uncomment to also skip symlinks even
                            # if they resolve to regular files
  f=$F
  mv -i -- "$F" "$f"
done

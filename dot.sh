#!/usr/bin/env bash

# dot.sh
# Date: 2022/06/06
# Modified: 2022/06/06
# Author: Nihar Sheth
# Toggle a file's visibility by adding/removing a "." to its filename.
# Usage: $ dot.sh file [...]

[ $# -ne 0 ] || { echo "❌ ERROR: No files passed." && exit 1; }

for file in "$@"; do
    [ ! -e "$file" ] && echo "❌ $file does not exist" && continue
    path=$(dirname "$file")
    [ ! -w "$path" ] && echo "🚫 $path cannot be written to." && continue
    
    filename=$(basename "$file")
    [[ "$filename" =~ ^\. ]] && mv "$file" "$path/${filename:1}" && echo "🌝 $file is now visible."
    [[ "$filename" =~ ^[A-z0-9_] ]] && mv "$file" "$path/.$filename" && echo "🌚 $file is now hidden."
done
exit 0
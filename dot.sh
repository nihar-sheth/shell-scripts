#!/usr/bin/env bash

# dot.sh
# Date: 2022/06/06
# Modified: 2022/06/07
# Author: Nihar Sheth
# Toggle a file's visibility by adding/removing a "." to its filename.
# Usage: $ dot.sh file [...]

[[ $# -ne 0 ]] || { echo "❌ ERROR: No files passed." && exit 1; }

for file in "$@"; do
    [[ -e "$file" ]] || { echo "🚫 $file does not exist." && continue; }
    path=$(dirname "$file")
    [[ -w "$path" ]] || { echo "⛔️ $path cannot be written to." && continue; }
    
    filename=$(basename "$file")

    # Make hidden file visible
    [[ "$filename" =~ ^\. ]] && {
        [[ -e "$path/${filename:1}" ]] && echo "🚫 $file: visible file by that name already exists." && continue
        mv "$file" "$path/${filename:1}" && echo "🌝 $file: visible."
    }

    # Make visible file hidden
    [[ "$filename" =~ ^[A-z0-9_] ]] && {
        [[ -e "$path/.$filename" ]] && echo "🚫 $file: hidden file by that name already exists." && continue
        mv "$file" "$path/.$filename" && echo "🌚 $file: hidden."
    }
done
exit 0
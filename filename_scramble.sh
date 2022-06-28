#!/usr/bin/env bash

# filename_scramble.sh
# Date: 2022/06/23
# Modified: 2022/06/23
# Author: Nihar Sheth
# Rename all non-hidden files in a directory to a random alphanumeric string filename.
# Usage: $ filename_scramble.sh [filename_length]

scramble() {
    find . -type f -depth 1 -not -path '*/.*' | while read file; do
        filename="$(basename "${file}")"
        new_filename="$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $1)"
        extension=".${filename#*.}"
        ! [[ "${filename}" =~ ^.+\..+$ ]] && extension=""
        
        mv "${filename}" "${new_filename}${extension}"
    done
}

case "$#" in
    0) scramble 20 ;;
    1) [[ "$1" =~ ^[0-9]+$ ]] && scramble "$1" || { echo "❌ ERROR: Integer input required" && exit 1; } ;;
    *) echo "❌ ERROR: Too many arguments." && exit 1 ;;
esac

exit 0
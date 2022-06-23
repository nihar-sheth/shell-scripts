#!/usr/bin/env bash

# write_tree.sh
# Date: 2022/06/23
# Modified: 2022/06/23
# Author: Nihar Sheth
# Write a tree-formatted directory listing to a text file.
# Usage: $ write_tree.sh [filename[.txt]]

verify_arg() {
    [[ "$1" =~ ^[A-z0-9_\-]+(\.txt)?$ ]] || { echo "❌ ERROR: Invalid filename." && exit 1; }
}

make_name() {
    [[ "$1" =~ .\.txt ]] && echo "$1" || echo "$1.txt"
}

write_to_file() {
    printf "Directory listing for $(pwd)\n[$(date)]\n" > "$1"
    tree -dn >> "$1"
}

main() {
    [[ -w "$(pwd)" ]] || { echo "⛔️ Current directory cannot be written to." && exit 1; }
    case "$#" in
        0) filename="directory_tree.txt" ;;
        1) filename="$(make_name "$1")" ;;
        *) echo "❌ ERROR: Too many arguments." && exit 1 ;;
    esac

    [[ -f "${filename}" ]] && {
        read -p "Overwrite existing text file? [yn]: " selection
        case "${selection}" in
            y) : ;;
            n) exit 0 ;;
            *) echo "❌ ERROR: Invalid selection." && exit 1 ;;
        esac
    }
    write_to_file "${filename}" 
}

main "$@" && exit 0
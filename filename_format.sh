#!/usr/bin/env bash

# filename_format.sh
# Date: 2022/05/31
# Modified: 2022/06/10
# Author: Nihar Sheth
# Convert a file or set of files' names to a standard format that I use across my personal directories.
# Usage: $ filename_format.sh file [...]

# Verify minimum number of arguments, if they exist and their validity
validate_args() {
	[[ $# -eq 0 ]] && echo "❌ ERROR: No files passed." >&2 && exit 1 
	for arg in "$@"; do
		[[ -e "$arg" ]] || { echo "❌ ERROR: $arg does not exist." >&2 && exit 1; }
		[[ -f "$arg" ]] || { echo "❌ ERROR: $arg is a directory." >&2 && exit 1; }
	done
}

main() {
	validate_args "$@"
	for file in "$@"; do
		absolute_path=$(dirname "$(realpath "$file")")
		converted_filename=$(basename "$file" | awk '{print tolower($0)}' | tr " " "_")
		mv "$file" "${absolute_path}/${converted_filename}"
	done
	echo "✅ Filenames successfully formatted!"
}

main "$@" && exit 0
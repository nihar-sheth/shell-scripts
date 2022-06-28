#!/usr/bin/env bash

# directory_format.sh
# Date: 2022/06/28
# Modified: 2022/06/28
# Author: Nihar Sheth
# Same as filename_format.sh but for directories only. I'll merge these into a single script in the future.
# Usage: $ directory_format.sh directory [...]

# Verify minimum number of arguments, if they exist and their validity
validate_args() {
	[[ $# -eq 0 ]] && echo "❌ ERROR: No directories passed." >&2 && exit 1 
	for arg in "$@"; do
		[[ -e "${arg}" ]] || { echo "❌ ERROR: "${arg}" does not exist." >&2 && exit 1; }
		[[ -d "${arg}" ]] || { echo "❌ ERROR: "${arg}" is not a directory." >&2 && exit 1; }
	done
}

main() {
	validate_args "$@"
	for dir in "$@"; do
		absolute_path=$(realpath "${dir}"/..)
		converted_dirname=$(basename "${dir}" | awk '{print tolower($0)}' | tr " " "_")
        mv "${dir}" "${absolute_path}/${converted_dirname}"
	done
	echo "✅ Directories successfully formatted!"
}

main "$@" && exit 0
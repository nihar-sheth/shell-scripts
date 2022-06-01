# filename_format.sh
# Date: 2022/05/31
# Modified: 2022/06/01
# Author: Nihar Sheth
# Convert a file or set of files' names to a standard format that I use across my personal directories.
# Usage: $ ./filename_format.sh file [...]

#!/usr/bin/env bash

# Verify minimum number of arguments passed
if [ $# -lt 1 ]; then
	echo "❌ ERROR: No files passed."
	exit 1
fi

# Verify all arguments passed are files before formatting
for arg in "$@"; do
	if ! [ -f "$arg" ]; then
		echo "❌ ERROR: $arg is not a file."
		exit 1
	fi
done

# Format each filename using absolute path for safety
for file in "$@"; do
	absolute_path=$(dirname "$(realpath "$file")")/
	converted_filename=$(basename "$file" | awk '{print tolower($0)}' | tr " " "_")
	mv "$file" "${absolute_path}${converted_filename}"
done

echo "✅ Filenames formatted!"
exit 0
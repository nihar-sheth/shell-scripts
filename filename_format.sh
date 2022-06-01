# filename_format.sh
# Date: 2022/05/31
# Modified: 2022/06/01
# Author: Nihar Sheth
# Convert a file or set of files' names to a standard format I use: all lowercase with underscores as spaces.
# Usage: $ ./filename_format.sh file ...

#!/usr/bin/env bash

# Verify minimum number of arguments
if [ $# -lt 1 ]; then
	echo "ERROR: No files passed."
	exit 1
fi

# Verify all arguments passed are files
for arg in $@; do
	if ! [ -f $arg ]; then
		echo "ERROR: $arg is not a file."
		exit 1
	fi
done

for file in $@; do
	absolute_path=$(dirname $(realpath $file))/
	filename=$(basename $file | awk -F '/' '{print tolower($NF)}') # TODO: Implement underscore replace
	mv $file ${absolute_path}$filename
done

exit 0
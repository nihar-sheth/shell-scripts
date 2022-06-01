#!/usr/bin/env bash

if [ $# -lt 1 ]; then
	echo "ERROR: No files passed."
	exit 1
fi

for file in $@; do
	echo $file
done


#!/usr/bin/env bash

# jedi.sh
# Date: 2022/06/21
# Modified: 2022/06/21
# Author: Nihar Sheth
# one-line description
# Usage: $ 

readonly quotes_file="/Users/nihar/dev/scripts/resources/jedi_quotes.txt"
[[ -f "${quotes_file}" ]] || { echo "❌ ERROR: File does not exist at $(dirname ${quotes_file})" && exit 1; }
declare -i line_count=$(wc -l < "${quotes_file}" | tr -d ' ')
selected_line=$(( $RANDOM % $line_count + 1 ))

sed -n "${selected_line}p" < "${quotes_file}"
exit 0
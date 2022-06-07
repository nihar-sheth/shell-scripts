#!/usr/bin/env bash

# timestamp.sh
# Date: 2022/06/07
# Modified: 2022/06/07
# Author: Nihar Sheth
# Update the modified date to the current date in my shell script headers.
# Usage: $ timestamp.sh script.sh [...]

[[ $# -ne 0 ]] || { echo "❌ ERROR: No scripts passed." && exit 1; }

readonly today=$(date "+%Y/%m/%d")
change_date() {
    # regexp: YYYY/MM/DD
    sed -i "\|# Modified|s|\([[:digit:]]\{2,4\}\/\?\)\{3\}|$today|" "$1"
}

for script in "$@"; do
    [[ -e "$script" ]] || { echo "🚫 $script does not exist." && continue; }
    filename=$(basename "$script")
    [[ ${filename#*.} == "sh" ]] || { echo "🚫 $filename is not a shell script." && continue; }
    change_date "$script" && echo "✅ $script header updated."
done
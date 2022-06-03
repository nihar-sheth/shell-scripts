# list_estatements.sh
# Date: 2022/06/02
# Modified: 2022/06/02
# Author: Nihar Sheth
# List eStatements for a given year in a readable list and interactively prompt to open its PDF file.
# Usage: list_estatements.sh [year]

#!/usr/bin/env bash

declare -r FILES=$(ls *.pdf)
declare -r YEARS=$(ls $FILES | awk '{print substr($0, 0, 4)}' | sort | uniq)
declare -r YEAR_RANGE=$(echo $YEARS | awk '{print $1"-"$NF}')
declare -r FILENAME_FORMAT="yyyy-mm-dd_yyyy_mm-dd.pdf"
declare -r FILENAME_PATTERN="(\d{2,4}[-_]?){6}"

# Validate that filenames match standard format before processing anything
validate_filenames() {
    for file in $FILES; do
        if ! echo $file | grep -Eq $FILENAME_PATTERN; then
            echo "❌ ERROR: $file has an invalid filename, please rename or remove it. [$FILENAME_FORMAT]" && exit 1
        fi
    done
}

# Validate correct year format and that is within the valid range with available dates from eStatements
validate_year() {
    if ! echo $1 | grep -Eq '\d{4}'; then
        echo "❌ ERROR: Invalid year format. [yyyy]" && exit 1
    elif ! [[ $YEARS == *$1* ]]; then
        echo "❌ ERROR: No eStatements available for $1. [$YEAR_RANGE]"&& exit 1
    fi
}

interactive_prompt() {
    read -p "Select year [$YEAR_RANGE]: " year
    validate_year $year && list $year
}

# Format dates in a list and prompt to open a file by its list number
list() {
    n=1
    selected_files=($(ls $1*.pdf))
    echo "\neStatements from $1:"
    for file in ${selected_files[@]}; do
        start_date=$(echo $file | cut -d. -f1 | awk -F '_' '{print $1}' | xargs date -jf %F "+%B")
        end_date=$(echo $file | cut -d. -f1 | awk -F '_' '{print $2}' | xargs date -jf %F "+%B")
        printf "%2d) %s to %s\n" $n $start_date $end_date
        (( n++ ))
    done

    echo ""
    read -p "Select file [#]: " file_number
    if [[ $file_number -gt n || $file_number -lt 1 ]]; then
        echo "❌ ERROR: Invalid file selection." && exit 1
    else
        file=${selected_files[(( $file_number - 1 ))]}
        open $file
        echo "✅ Opened $file" && exit 0
    fi
}

# Allow for a year to be passed directly, bypassing the interactive prompt
case $# in
    0) validate_filenames && interactive_prompt;;
    1) validate_filenames && validate_year $1 && list $1;;
    *) echo "❌ ERROR: Too many arguments passed. [year]"; exit 1;;
esac
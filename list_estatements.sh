# list_estatements.sh
# Date: 2022/06/02
# Modified: 2022/06/04
# Author: Nihar Sheth
# List eStatements for a given year in a readable list and interactively prompt to open its PDF file.
# Usage: $ list_estatements.sh [year]

#!/usr/bin/env bash

shopt -s nocasematch

# Validate working directory and set directory-specific filename format parameters
set_directory() {
    readonly WORKING_DIRECTORY=$(pwd | awk -F '/' '{print $NF}')

    # Add future directories here
    case $WORKING_DIRECTORY in
        "chequing")
            readonly FILENAME_PATTERN="^\d{4}-\d{2}"
            readonly FILENAME_FORMAT="yyyy-mm.pdf"
            readonly DATE_STRING_COMMAND='echo $file | cut -d. -f1 | xargs date -jf %Y-%m "+%B"';;
        "cibc_visa")
            readonly FILENAME_PATTERN="^\d{4}-\d{2}-\d{2}_\d{4}-\d{2}-\d{2}"
            readonly FILENAME_FORMAT="yyyy-mm-dd_yyyy_mm-dd.pdf"
            readonly DATE_STRING_COMMAND='echo $file | cut -d. -f1 | awk -F_ '"'"'{system("date -jf %F \"+%B\" " $1); print "to"; system("date -jf %F \"+%B\" " $2)}'"'"' | tr "\n" " "';;
        *)
            echo "❌ ERROR: Cannot execute script from an invalid directory." && exit 1;;
    esac
}

# Validate that filenames match standard format before processing anything
validate_filenames() {
    readonly FILES=$(ls *.pdf)
    readonly YEARS=$(ls $FILES | awk '{print substr($0, 0, 4)}' | sort | uniq)
    readonly YEAR_RANGE=$(echo $YEARS | awk '{print $1"-"$NF}')
    for file in $FILES; do
        if ! echo $file | grep -Eq $FILENAME_PATTERN; then
            echo "❌ ERROR: $file has an invalid filename, please rename or remove it. [$FILENAME_FORMAT]" && exit 1
        fi
    done
}

# Validate correct year format and that is within the valid range with dates available from eStatements
validate_year() {
    if ! echo $1 | grep -Eq '^\d{4}$'; then
        echo "❌ ERROR: Invalid year format. [yyyy]" && exit 1
    elif ! [[ $YEARS == *$1* ]]; then
        echo "❌ ERROR: No eStatements available for $1. [$YEAR_RANGE]"&& exit 1
    fi
}

# Exit program during interactive prompts
exit_check() {
    readonly EXIT_COMMANDS=("e" "exit" "cancel")
    if [[ "${EXIT_COMMANDS[*]}" =~ "$1" ]]; then
        exit 0
    fi
}

interactive_prompt() {
    read -p "Select year [$YEAR_RANGE]: " year
    exit_check $year
    validate_year $year && list $year
}

# Open file from numbered list
file_prompt() {
    read -p "Select file [#]: " file_number
    exit_check $file_number
    if ! echo $file_number | grep -Eq '^\d+$'; then
        echo "❌ ERROR: Integer selection required." && exit 1
    elif [[ $file_number -ge $1 || $file_number -lt 1 ]]; then
        echo "❌ ERROR: Out of selection range." && exit 1
    else
        readonly SELECTED_FILE=${SELECTED_FILES[(( $file_number - 1 ))]}
        open $SELECTED_FILE
        echo "✅ Opened $SELECTED_FILE"
    fi
}

# Format dates in a list and prompt to open a file
list() {
    declare -i n=1
    declare date_str
    readonly SELECTED_FILES=($(ls $1*.pdf))
    echo "\neStatements from $1:"
    for file in ${SELECTED_FILES[@]}; do
        date_str=$(eval "$DATE_STRING_COMMAND")
        printf "%2d) %s\n" $n "$date_str"
        (( n++ ))
    done

    echo "" && file_prompt $n
}

main() {
    set_directory && validate_filenames

    # Allow for a year to be passed directly, bypassing the interactive prompt
    case $# in
        0) interactive_prompt;;
        1) validate_year $1 && list $1;;
        *) echo "❌ ERROR: Too many arguments passed. [year]"; exit 1;;
    esac
}

main $@ && exit 0
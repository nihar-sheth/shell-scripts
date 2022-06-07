#!/usr/bin/env bash

# setup_sandbox.sh
# Date: 2022/06/05
# Modified: 2022/06/07
# Author: Nihar Sheth
# Quickly generate a sandbox directory with dummy files of various types for testing other scripts.
# Usage: $ setup_sandbox.sh

readonly DIR_NAME="sandbox_$(date "+%F")/"
readonly DIR_FORMAT="sandbox_????-??-??/"

exists() {
    [[ -d $1 ]]
}

writeable() {
    [[ -w $1 ]]
}

# Make directory and populate with files
generate() {
    [[ -w "$(pwd)" ]] || { echo "❌ ERROR: Working directory cannot be written to." && exit 1; }

    mkdir $DIR_NAME && cd $DIR_NAME
    touch "text_file_"{1..10}".txt" "image_file_"{1..5}".jpeg"
    touch "extensionless_file"{1..5} ".hidden_file_"{1..5}
    touch "ALL_CAPS_FILENAME.txt" "all_caps_extension_"{1..3}".PDF"
    touch "A TERRIBLE filename syntax "{1..3}".png"
    mkdir "subdirectory_"{1..3}
    touch "subdirectory_"{1..3}"/sub_files_"{1..5}
}

# Add sandbox directory to .gitignore if it exists
[[ -a ".gitignore" && ! $(grep "^${DIR_FORMAT}" ".gitignore") ]] && printf "\n%s" "$DIR_FORMAT" >> ".gitignore"

# Add write permission to existing sandbox directory if required and remove it
if exists "sandbox_"????-??-??/; then
    writeable "sandbox_"????-??-??/ || { echo "⚠️ Existing sandbox directory is missing write permissions, updating." && chmod +w $DIR_FORMAT; }
    rm -rf $DIR_FORMAT && echo "✅ Removed existing sandbox directory."
fi
generate
echo "✅ Sandbox directory generated and populated at $DIR_NAME" && exit 0;
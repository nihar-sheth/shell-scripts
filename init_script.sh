#!/usr/bin/env bash

# init_script.sh
# Date: 2022/06/07
# Modified: 2022/06/10
# Author: Nihar Sheth
# Generate a script, populate header fields and grant it execution permissions.
# Usage: $ init_script.sh [script ...]

shopt -s nocasematch

readonly HEADER_TEMPLATE="/Users/nihar/dev/scripts/.header_template.txt"
[[ -e "${HEADER_TEMPLATE}" ]] || { echo "❌ ERROR: Could not find header template." >&2 && exit 1; }

validate_args() {
    for arg in "$@"; do
        [[ "${arg}" =~ ^e$ ]] && exit 0
        [[ -z "${arg}" ]] && echo "❌ ERROR: No names passed." >&2 && exit 1
    done
}

interactive_prompt() {
    read -p "Enter script name to make: " name
    validate_args "${name}"
    main "${name}" 
}

make_name() {
    [[ "$1" =~ .\.sh ]] && echo "$1" || echo "$1.sh"
}

readonly today=$(date "+%Y/%m/%d")
make_script() {
    path="$(dirname "$1")"
    [[ -d "${path}" ]] || { echo "🚫 $1 has an invalid path." >&2 && return; }
    [[ -w "$path" ]] || { echo "⛔️ ${path} cannot be written to." >&2 && return; }
    [[ -e "$1" ]] && echo "🚫 $1 already exists." >&2 && return
    cat "${HEADER_TEMPLATE}" > "$1" && chmod +x "$1"
    
    script_name="$(basename "$1")"
    sed -i "s|script_name|${script_name%.*}|" "$1"
    sed -i "s|date_created|${today}|" "$1"
    sed -i "s|date_modified|${today}|" "$1"

    echo "✅ ${script_name} is ready to go."
}

main() {
    for arg in "$@"; do
        name="$(make_name "${arg}")"
        make_script "${name}"
    done
}

case $# in
    0) interactive_prompt ;;
    *) main "$@" ;;
esac

exit 0
#!/usr/bin/env bash

# get_template.sh
# Date: 2022/06/06
# Modified: 2022/06/10
# Author: Nihar Sheth
# Copy my standard script header template to the system clipboard.
# Usage: $ get_template.sh

readonly HEADER_TEMPLATE="/Users/nihar/dev/scripts/.header_template.txt"
[[ -e "${HEADER_TEMPLATE}" ]] \
    && { cat "${HEADER_TEMPLATE}" | pbcopy; exit 0; } \
    || { echo "❌ ERROR: No template file found at $(dirname "${HEADER_TEMPLATE}")" >&2 && exit 1; }
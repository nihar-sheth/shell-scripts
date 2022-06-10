#!/usr/bin/env bash

# get_template.sh
# Date: 2022/06/06
# Modified: 2022/06/10
# Author: Nihar Sheth
# Copy my standard script header template to the system clipboard.
# Usage: $ get_template.sh

readonly template_file=".header_template.txt"
[[ -e "$template_file" ]] && { cat $template_file | pbcopy; exit 0; } || { echo "❌ ERROR: No template file found." >&2 && exit 1; }
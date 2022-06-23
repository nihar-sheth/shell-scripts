#!/usr/bin/env bash

# my_scripts.sh
# Date: 2022/06/23
# Modified: 2022/06/23
# Author: Nihar Sheth
# Utility to list all scripts in my scripts directory.
# Usage: $ my_scripts.sh

readonly scripts_directory="/Users/nihar/dev/scripts"
find "${scripts_directory}" -type f -name "*.sh" 2>/dev/null | awk -F/ '{print $NF}'
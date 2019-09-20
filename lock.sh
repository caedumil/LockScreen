#!/usr/bin/env bash

#
# Based on scripts from
# https://www.reddit.com/r/unixporn/comments/3358vu/i3lock_unixpornworthy_lock_screen
#

set -e

# Check dependencies
checkdep() {
    if ! command -v ${1} >/dev/null 2>&1; then
        echo "Error: ${1} not found."
        exit 1
    fi
}

checkdep scrot
checkdep convert
checkdep i3lock

# Setup variables
sshot="$(mktemp --suffix=.png)"
[[ -n ${1} ]] && icon="$(realpath ${1})"

# Take screenshot
scrot --overwrite "${sshot}"

# Pixelate image
convert "${sshot}" -scale 10% -scale 1000% "${sshot}"

# Add lock icon to screenshot
if [[ -f ${icon} ]]; then
    convert "${sshot}" "${icon}" -gravity center -composite -matte "${sshot}"
fi

# Lock screen
i3lock --ignore-empty-password --no-unlock-indicator --image "${sshot}"

# Cleanup
rm "${sshot}"

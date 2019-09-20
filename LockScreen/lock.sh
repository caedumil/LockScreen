#!/usr/bin/env bash

#
# Based on scripts from
# https://www.reddit.com/r/unixporn/comments/3358vu/i3lock_unixpornworthy_lock_screen
#

set -e

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
i3lock --no-unlock-indicator --image "${sshot}"

# Cleanup
rm "${sshot}"

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
if [[ -f "${icon}" ]]; then
    # placement x/y
    PX=0
    PY=0
    # lockscreen image info
    R=$(file "${icon}" | grep -o '[0-9]* x [0-9]*')
    RX=$(echo $R | cut -d' ' -f 1)
    RY=$(echo $R | cut -d' ' -f 3)

    SR=$(xrandr --query | grep -E -o -e '[0-9]+x[0-9]+\+[0-9]+\+[0-9]')
    for RES in $SR; do
        # monitor position/offset
        SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
        SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
        SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
        SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
        PX=$(($SROX + $SRX/2 - $RX/2))
        PY=$(($SROY + $SRY/2 - $RY/2))

        # add icon
        convert "${sshot}" "${icon}" -geometry +$PX+$PY -composite -matte "${sshot}"
    done
fi

# Lock screen
i3lock --ignore-empty-password --no-unlock-indicator --image "${sshot}"

# Cleanup
rm "${sshot}"

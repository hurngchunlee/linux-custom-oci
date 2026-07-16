#!/bin/bash

set -euo pipefail

SRC_ROOT="/usr/etc"
DST_ROOT="/etc"

if [[ ! -d "$SRC_ROOT" ]]; then
    exit 0
fi

controlled_files=(
    "$SRC_ROOT/ssh/sshd_config"
    "$SRC_ROOT/ssh/sshd_config.d"
    "$SRC_ROOT/sudoers"
    "$SRC_ROOT/sudoers.d"
    "$SRC_ROOT/sysctl.conf"
    "$SRC_ROOT/sysctl.d"
)


mount_readonly()
{
    local src="$1"
    local dst="$2"

    echo "Managing $dst from $src"

    # Ensure target exists
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
    else
        mkdir -p "$(dirname "$dst")"
        touch "$dst"
    fi

    # Avoid duplicate mounts
    if mountpoint -q "$dst"; then
        echo "$dst already mounted"
        return
    fi

    mount --bind -o ro "$src" "$dst"

}

for src in "${controlled_files[@]}"; do
    relative="${src#$SRC_ROOT}"
    dst="${DST_ROOT}${relative}"
    mount_readonly "$src" "$dst"
done
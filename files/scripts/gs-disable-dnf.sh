#!/usr/bin/env bash

set -euo pipefail

mkdir -p /usr/lib64/gnome-software/plugins-23.disabled
mv /usr/lib64/gnome-software/plugins-23/libgs_plugin_dnf*.so /usr/lib64/gnome-software/plugins-23.disabled/
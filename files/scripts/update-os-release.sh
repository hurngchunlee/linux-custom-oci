#!/usr/bin/env bash
set -euo pipefail

BASE_VERSION=$(grep '^VERSION_ID=' /usr/lib/os-release | cut -d= -f2)

VERSION="${BASE_VERSION}.${IMAGE_VERSION:-unknown}"

sed -i \
  "s/^VERSION=.*/VERSION=\"${VERSION} (Silverblue Custom)\"/" \
  /usr/lib/os-release

sed -i \
  "s/^PRETTY_NAME=.*/PRETTY_NAME=\"Fedora Linux ${VERSION} (Silverblue Custom)\"/" \
  /usr/lib/os-release

sed -i \
  "s/^OSTREE_VERSION=.*/OSTREE_VERSION='${VERSION}'/" \
  /usr/lib/os-release
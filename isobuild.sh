#!/bin/bash

sudo podman run --network=host --rm -it --privileged --pull=newer --security-opt label=type:unconfined_t -v ./isobuild.toml:/config.toml:ro -v ./output:/output -v /var/lib/containers/storage:/var/lib/containers/storage ghcr.io/osbuild/bootc-image-builder:latest -v --log-level debug --type anaconda-iso --rootfs xfs ghcr.io/hurngchunlee/laptop-fedora-gnome:44

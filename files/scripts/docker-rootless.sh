#!/usr/bin/env bash
set -euo pipefail

# docker-rootless.sh — configure rootless Docker at image build time
#
# Source: modules/docker.nix
#   virtualisation.docker.enable = false              (no system daemon)
#   virtualisation.docker.rootless.enable = true      (per-user rootless daemon)
#   virtualisation.docker.rootless.setSocketVariable = true
#     (DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock)
#
# What this script does:
#   1. Enables the rootless Docker user service globally for all users
#      (equivalent to `systemctl --global enable docker.service`).
#      Each user's Docker daemon starts automatically on login via their
#      own systemd user session — no root daemon runs.
#   2. Drops a profile.d snippet that sets DOCKER_HOST for all login shells,
#      mirroring NixOS's setSocketVariable = true behaviour.
#
# The system docker.service (root daemon) is deliberately NOT enabled.

# ---------------------------------------------------------------------------
# 1. Enable the rootless Docker socket + service for all users globally
# ---------------------------------------------------------------------------
#systemctl --global enable docker

# ---------------------------------------------------------------------------
# 2. Set DOCKER_HOST for all users via /etc/profile.d
#    Points to the per-user XDG_RUNTIME_DIR socket (rootless mode).
# ---------------------------------------------------------------------------
cat > /etc/profile.d/docker-rootless.sh << 'EOF'
# Set DOCKER_HOST for rootless Docker (per-user daemon via systemd user session)
export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/docker.sock"
EOF

#!/usr/bin/env bash
set -euo pipefail

# firewall.sh — configure firewalld at image build time
#
# Source: modules/networking.nix
#   networking.firewall.enable = true        (firewalld already active by default)
#   networking.firewall.allowedTCPPorts = [] (no extra ports open)
#   networking.firewall.allowedUDPPorts = [] (no extra ports open)
#   networking.firewall.allowPing = false    (block ICMP echo)
#   services.avahi.openFirewall = true       (mDNS 5353/UDP stays open — default in FedoraWorkstation zone)
#
# Additional requirement: allow all inbound traffic from localhost.
#
# Uses firewall-offline-cmd — operates on /etc/firewalld/ config files
# directly without requiring a running firewalld daemon. Safe at build time.

# ---------------------------------------------------------------------------
# 1. Block ICMP ping (echo-request / echo-reply) on the default external zone
#    The FedoraWorkstation zone permits ping by default; this removes that.
# ---------------------------------------------------------------------------
firewall-offline-cmd --zone=FedoraWorkstation --add-icmp-block=echo-request
firewall-offline-cmd --zone=FedoraWorkstation --add-icmp-block=echo-reply

# ---------------------------------------------------------------------------
# 2. Allow all traffic originating from localhost (loopback / 127.0.0.1 / ::1)
# ---------------------------------------------------------------------------
firewall-offline-cmd --zone=trusted --add-interface=lo

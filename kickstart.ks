# kickstart.ks — Anaconda automated install for laptop-fedora-gnome
# Fully automated except for the LUKS passphrase prompt.
#
# Usage (embedded in ISO at build time):
#   sudo bluebuild generate-iso \
#     --iso-name laptop-fedora-gnome.iso \
#     --kickstart kickstart.ks \
#     recipe recipe.yml

# ---------------------------------------------------------------------------
# %pre — calculate swap size based on physical RAM (for hibernation support)
# Runs before the rest of the kickstart is parsed.
# RAM × 1.2, rounded down to nearest MB — matches NixOS install.sh logic.
# ---------------------------------------------------------------------------
%pre
#!/bin/bash
RAM_MB=$(free -m | awk '/^Mem:/{print $2}')
SWAP_MB=$(echo "$RAM_MB * 1.2 / 1" | bc)
echo "part swap --size=${SWAP_MB}" > /tmp/swap-size.ks
%end

# ---------------------------------------------------------------------------
# Installer display mode — non-interactive except for LUKS passphrase prompt
# ---------------------------------------------------------------------------
cmdline

# ---------------------------------------------------------------------------
# Locale — from modules/common.nix
#   time.timeZone = "Europe/Amsterdam"
#   i18n.defaultLocale = "en_US.UTF-8"
# ---------------------------------------------------------------------------
lang en_US.UTF-8
keyboard --xlayouts=us
timezone Europe/Amsterdam --utc

# ---------------------------------------------------------------------------
# Disk layout — from install.sh
# Wipes all existing partitions and creates a clean GPT layout.
# The LUKS passphrase for the root partition is prompted interactively.
# ---------------------------------------------------------------------------
zerombr
clearpart --all --initlabel --disklabel=gpt

# EFI System Partition (512 MB, FAT32)
part /boot/efi  --fstype=efi  --size=512  --label=boot

# Swap — size injected here from %pre calculation (RAM × 1.2 MB)
%include /tmp/swap-size.ks

# Root partition — LUKS2-encrypted XFS, takes all remaining space
# Passphrase is prompted interactively (no --passphrase option)
part /  --fstype=xfs  --grow  --encrypted  --luks-version=luks2  --label=root

# ---------------------------------------------------------------------------
# Bootloader — EFI
# ---------------------------------------------------------------------------
bootloader --location=mbr

# ---------------------------------------------------------------------------
# Security — lock root account, no direct root login
# User account is created by GNOME initial-setup on first boot
# ---------------------------------------------------------------------------
rootpw --lock

# ---------------------------------------------------------------------------
# Reboot automatically after installation completes
# ---------------------------------------------------------------------------
reboot

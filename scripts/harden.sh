#!/usr/bin/env bash
# Basic hardening, run on each server: sudo bash scripts/harden.sh
set -euo pipefail                      # stop at the first error
export DEBIAN_FRONTEND=noninteractive  # no interactive prompts during installs

# 1. System updates
apt-get update
apt-get upgrade -y

# 2. Hardened SSH configuration
cp config/sshd/10-argus.conf /etc/ssh/sshd_config.d/
sshd -t                                # check the config before applying it
systemctl reload ssh

# 3. Firewall: allow SSH BEFORE enabling it
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw --force enable                     # --force = answer "y" automatically

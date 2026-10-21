#!/usr/bin/env bash
# Show the fail2ban SSH jail on srv-app: failures, bans, banned IPs
# Usage, from the repository root: ./scripts/utils/bans.sh
set -euo pipefail
source scripts/env.sh > /dev/null

ssh -i ~/.ssh/argus ubuntu@$APP "sudo fail2ban-client status sshd"

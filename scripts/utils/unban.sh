#!/usr/bin/env bash
# Lift the ban of srv-argus on srv-app after the attack demo
# Usage, from the repository root: ./scripts/utils/unban.sh
set -euo pipefail
source scripts/env.sh > /dev/null

ssh -i ~/.ssh/argus ubuntu@$APP "sudo fail2ban-client set sshd unbanip $ARGUS_PRIVATE"

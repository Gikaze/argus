#!/usr/bin/env bash
# Fake SSH attack from srv-argus on srv-app: fail2ban bans srv-argus after 3 failures
# srv-argus has no key for srv-app, so every login fails
# Usage, from the repository root: ./scripts/utils/attack.sh
set -euo pipefail
source scripts/env.sh > /dev/null

ssh -i ~/.ssh/argus ubuntu@$ARGUS \
  "for i in 1 2 3 4 5; do echo \"Attempt \$i:\"; ssh -o BatchMode=yes -o ConnectTimeout=3 -o StrictHostKeyChecking=accept-new ubuntu@$APP_PRIVATE true; sleep 2; done"

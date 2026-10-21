#!/usr/bin/env bash
# Simulate an Nginx crash: systemd restarts it after 5 seconds, so no alert is expected
# Usage, from the repository root: ./scripts/utils/crash-nginx.sh
set -euo pipefail
source scripts/env.sh > /dev/null

ssh -i ~/.ssh/argus ubuntu@$APP \
  "sudo kill -9 \$(systemctl show nginx -p MainPID --value); sleep 7; systemctl is-active nginx; systemctl show nginx -p NRestarts"

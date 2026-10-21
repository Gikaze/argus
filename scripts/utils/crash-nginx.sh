#!/usr/bin/env bash
# Simulate an Nginx crash: systemd restarts it after 5 seconds, so no alert is expected
# Usage, from the repository root: ./scripts/utils/crash-nginx.sh
set -euo pipefail
source scripts/env.sh > /dev/null

# Single quotes: everything below runs on srv-app, including $(...)
ssh -i ~/.ssh/argus ubuntu@$APP '
  echo "=== Nginx before the crash ==="
  systemctl show nginx -p MainPID -p NRestarts
  echo "=== Killing Nginx with kill -9 (simulated crash) ==="
  sudo kill -9 $(systemctl show nginx -p MainPID --value)
  echo "=== Waiting 7 seconds for systemd ==="
  sleep 7
  echo "=== Nginx after the crash ==="
  systemctl is-active nginx
  systemctl show nginx -p MainPID -p NRestarts
'

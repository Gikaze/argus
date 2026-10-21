#!/usr/bin/env bash
# Stop, start or check a service on srv-app (alert demos)
# Usage: ./scripts/utils/service.sh stop|start|status nginx|fail2ban|prometheus-node-exporter
set -euo pipefail
ACTION=${1:?Usage: service.sh stop|start|status <service>}
SERVICE=${2:?Usage: service.sh stop|start|status <service>}
source scripts/env.sh > /dev/null

ssh -i ~/.ssh/argus ubuntu@$APP "sudo systemctl $ACTION $SERVICE; echo \"$SERVICE is now: \$(systemctl is-active $SERVICE)\""

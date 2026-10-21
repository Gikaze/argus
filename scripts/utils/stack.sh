#!/usr/bin/env bash
# Manage the monitoring containers on srv-argus
# Usage: ./scripts/utils/stack.sh ps | stop <service> | start <service> | logs <service>
#        services: prometheus, alertmanager, grafana
set -euo pipefail
ACTION=${1:?Usage: stack.sh ps|stop|start|logs [service]}
SERVICE=${2:-}                        # optional: empty means all services
source scripts/env.sh > /dev/null

ssh -i ~/.ssh/argus ubuntu@$ARGUS "sudo docker compose --project-directory /opt/argus $ACTION $SERVICE"

#!/usr/bin/env bash
# Open the SSH tunnel to the monitoring tools on srv-argus (Ctrl+C to close)
# Usage, from the repository root: ./scripts/utils/tunnel.sh
set -euo pipefail
source scripts/env.sh > /dev/null

echo "Grafana http://localhost:3000 | Prometheus http://localhost:9090 | Alertmanager http://localhost:9093"
echo "Tunnel open, Ctrl+C to close"
ssh -i ~/.ssh/argus -N -o ServerAliveInterval=60 \
  -L 3000:localhost:3000 -L 9090:localhost:9090 -L 9093:localhost:9093 ubuntu@$ARGUS

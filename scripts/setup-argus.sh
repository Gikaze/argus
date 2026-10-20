#!/usr/bin/env bash
# srv-argus: install the monitoring stack (Prometheus + Grafana)
# Run on srv-argus: sudo APP_PRIVATE_IP=... GRAFANA_PASSWORD=... SNS_TOPIC_ARN=... bash scripts/setup-argus.sh
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# 1. Install Docker and Docker Compose (Ubuntu packages)
apt-get install -y docker.io docker-compose-v2

# 2. Copy the monitoring configuration to /opt/argus
mkdir -p /opt/argus
cp -r config/monitoring/. /opt/argus/

# 3. Tell Prometheus where srv-app is (its private IP changes at every deployment)
sed -i "s/APP_PRIVATE_IP/$APP_PRIVATE_IP/" /opt/argus/prometheus.yml
sed -i "s/SNS_TOPIC_ARN/$SNS_TOPIC_ARN/" /opt/argus/alertmanager.yml

# 4. Grafana admin password, readable by root only
echo "GF_SECURITY_ADMIN_PASSWORD=$GRAFANA_PASSWORD" > /opt/argus/.env
chmod 600 /opt/argus/.env

# 5. Check the Prometheus configuration and alert rules before starting
docker run --rm -v /opt/argus:/etc/prometheus --entrypoint promtool \
  prom/prometheus:v3.5.0 check config /etc/prometheus/prometheus.yml

docker run --rm -v /opt/argus:/etc/alertmanager --entrypoint amtool \
  prom/alertmanager:v0.28.1 check-config /etc/alertmanager/alertmanager.yml

# 6. Start the stack, recreating the containers so they read the latest configuration
docker compose --project-directory /opt/argus up -d --force-recreate



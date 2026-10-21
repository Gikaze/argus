#!/usr/bin/env bash
# srv-app: install the LogiTrans web portal
# Run on srv-app: sudo bash scripts/setup-app.sh
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# 1. Install Nginx
apt-get install -y nginx

# 2. Publish the LogiTrans portal page
cp config/nginx/index.html /var/www/html/index.html

# 3. Restart Nginx automatically if it crashes
mkdir -p /etc/systemd/system/nginx.service.d
cp config/nginx/10-argus-restart.conf /etc/systemd/system/nginx.service.d/
systemctl daemon-reload
nginx -t                               # check the Nginx config before restarting
systemctl restart nginx

# 4. Firewall: open the web port
ufw allow 80/tcp


# 5. node_exporter: system and service metrics for Prometheus
apt-get install -y prometheus-node-exporter
cp config/node-exporter/prometheus-node-exporter /etc/default/prometheus-node-exporter
systemctl restart prometheus-node-exporter

# 6. Firewall: metrics port open to the internal network (VPC) only
ufw allow from 10.0.0.0/16 to any port 9100 proto tcp



# 7. fail2ban: ban IPs after repeated failed SSH logins (admin IP whitelisted)
apt-get install -y fail2ban python3-systemd
sed "s/ADMIN_IP/$ADMIN_IP/" config/fail2ban/argus.local > /etc/fail2ban/jail.d/argus.local
fail2ban-client -t                     # check the fail2ban config before restarting
systemctl restart fail2ban





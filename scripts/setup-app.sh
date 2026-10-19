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

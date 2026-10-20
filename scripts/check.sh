#!/usr/bin/env bash
# Check the hardening on both servers
# Usage, from the repository root: ./scripts/check.sh
set -uo pipefail   # no "-e": every check must run, even if one fails

KEY=~/.ssh/argus
SSH_OPTS="-o StrictHostKeyChecking=accept-new -o BatchMode=yes"
APP=$(terraform -chdir=terraform output -raw srv_app_public_ip)
ARGUS=$(terraform -chdir=terraform output -raw srv_argus_public_ip)
APP_PRIVATE=$(terraform -chdir=terraform output -raw srv_app_private_ip)

for IP in $APP $ARGUS; do
  if [ "$IP" = "$APP" ]; then NAME=srv-app; else NAME=srv-argus; fi
  echo "=== Checking $NAME ($IP) ==="

  echo "--- Login without a key (must be refused):"
  ssh $SSH_OPTS -o PubkeyAuthentication=no ubuntu@$IP true 2>&1 | tail -1

  echo "--- Effective SSH settings:"
  ssh $SSH_OPTS -i $KEY ubuntu@$IP "sudo sshd -T | grep -E '^(passwordauthentication|permitrootlogin|maxauthtries)'"

  echo "--- Firewall:"
  ssh $SSH_OPTS -i $KEY ubuntu@$IP "sudo ufw status"
done

echo "=== Checking the portal on srv-app ($APP) ==="
echo "--- Web page (must show the portal title):"
curl -s -m 5 http://$APP | grep -o '<h1>.*</h1>' || echo "FAILED: portal not reachable"

echo "--- Nginx service and restart policy:"
ssh $SSH_OPTS -i $KEY ubuntu@$APP "systemctl is-active nginx; systemctl show nginx -p Restart"


echo "=== Checking the metrics of srv-app ($APP) ==="
echo "--- From srv-argus, over the internal network (must show nginx active = 1):"
ssh $SSH_OPTS -i $KEY ubuntu@$ARGUS "curl -s -m 3 http://$APP_PRIVATE:9100/metrics | grep 'nginx.service\",state=\"active\"'"

echo "--- From the Internet (must NOT be reachable):"
curl -s -m 5 http://$APP:9100/metrics > /dev/null && echo "FAILED: metrics exposed to the Internet" || echo "OK: not reachable from the Internet"


echo "=== Checking fail2ban on srv-app ($APP) ==="
echo "--- Service and SSH jail:"
ssh $SSH_OPTS -i $KEY ubuntu@$APP "systemctl is-active fail2ban; sudo fail2ban-client status sshd | grep -E 'Total failed|Currently banned'"

echo "--- Seen by node_exporter from srv-argus (must show fail2ban active = 1):"
ssh $SSH_OPTS -i $KEY ubuntu@$ARGUS "curl -s -m 3 http://$APP_PRIVATE:9100/metrics | grep 'fail2ban.service\",state=\"active\"'"


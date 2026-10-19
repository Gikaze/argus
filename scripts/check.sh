#!/usr/bin/env bash
# Check the hardening on both servers
# Usage, from the repository root: ./scripts/check.sh
set -uo pipefail   # no "-e": every check must run, even if one fails

KEY=~/.ssh/argus
SSH_OPTS="-o StrictHostKeyChecking=accept-new -o BatchMode=yes"
APP=$(terraform -chdir=terraform output -raw srv_app_public_ip)
ARGUS=$(terraform -chdir=terraform output -raw srv_argus_public_ip)

for IP in $APP $ARGUS; do
  echo "=== Checking $IP ==="

  echo "--- Login without a key (must be refused):"
  ssh $SSH_OPTS -o PubkeyAuthentication=no ubuntu@$IP true 2>&1 | tail -1

  echo "--- Effective SSH settings:"
  ssh $SSH_OPTS -i $KEY ubuntu@$IP "sudo sshd -T | grep -E '^(passwordauthentication|permitrootlogin|maxauthtries)'"

  echo "--- Firewall:"
  ssh $SSH_OPTS -i $KEY ubuntu@$IP "sudo ufw status"
done

echo "=== Checking the portal on $APP ==="
echo "--- Web page (must show the portal title):"
curl -s -m 5 http://$APP | grep -o '<h1>.*</h1>' || echo "FAILED: portal not reachable"

echo "--- Nginx service and restart policy:"
ssh $SSH_OPTS -i $KEY ubuntu@$APP "systemctl is-active nginx; systemctl show nginx -p Restart"

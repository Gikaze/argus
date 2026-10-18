#!/usr/bin/env bash
# Check the hardening on both servers
# Usage, from the repository root: ./scripts/check.sh
set -uo pipefail   # no "-e": every check must run, even if one fails

KEY=~/.ssh/argus
APP=$(terraform -chdir=terraform output -raw srv_app_public_ip)
ARGUS=$(terraform -chdir=terraform output -raw srv_argus_public_ip)

for IP in $APP $ARGUS; do
  echo "=== Checking $IP ==="

  echo "--- Login without a key (must be refused):"
  ssh -o PubkeyAuthentication=no -o BatchMode=yes ubuntu@$IP true 2>&1 | tail -1

  echo "--- Effective SSH settings:"
  ssh -i $KEY ubuntu@$IP "sudo sshd -T | grep -E '^(passwordauthentication|permitrootlogin|maxauthtries)'"

  echo "--- Firewall:"
  ssh -i $KEY ubuntu@$IP "sudo ufw status"
done

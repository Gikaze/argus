#!/usr/bin/env bash
# Copy the scripts to both servers and run the hardening
# Usage, from the repository root: ./scripts/deploy.sh
set -euo pipefail

KEY=~/.ssh/argus
SSH_OPTS="-i $KEY -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5"
APP=$(terraform -chdir=terraform output -raw srv_app_public_ip)
ARGUS=$(terraform -chdir=terraform output -raw srv_argus_public_ip)

for IP in $APP $ARGUS; do
  echo "=== Waiting for SSH on $IP ==="
  until ssh $SSH_OPTS ubuntu@$IP true 2>/dev/null; do
    sleep 5
  done

  echo "=== Hardening $IP ==="
  scp $SSH_OPTS -r scripts config ubuntu@$IP:~/
  ssh $SSH_OPTS ubuntu@$IP "sudo bash scripts/harden.sh"
done

#!/usr/bin/env bash
# Copy the scripts to both servers and run the hardening
# Usage, from the repository root: ./scripts/deploy.sh
set -euo pipefail

KEY=~/.ssh/argus
APP=$(terraform -chdir=terraform output -raw srv_app_public_ip)
ARGUS=$(terraform -chdir=terraform output -raw srv_argus_public_ip)

for IP in $APP $ARGUS; do
  echo "=== Hardening $IP ==="
  scp -i $KEY -o StrictHostKeyChecking=accept-new -r scripts config ubuntu@$IP:~/
  ssh -i $KEY ubuntu@$IP "sudo bash scripts/harden.sh"
done

#!/usr/bin/env bash
# Set the server IPs as variables in the current terminal
# Usage, from the repository root: source scripts/env.sh
export APP=$(terraform -chdir=terraform output -raw srv_app_public_ip)
export ARGUS=$(terraform -chdir=terraform output -raw srv_argus_public_ip)
echo "APP=$APP  ARGUS=$ARGUS"

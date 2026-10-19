#!/usr/bin/env bash
# Update the admin IP in terraform.tfvars if the public IP has changed
# Usage, from the repository root: ./scripts/update-ip.sh
set -euo pipefail

TFVARS=terraform/terraform.tfvars
CURRENT=$(curl -s https://checkip.amazonaws.com)/32
SAVED=$(grep my_ip_cidr "$TFVARS" | cut -d'"' -f2)

if [ "$CURRENT" = "$SAVED" ]; then
  echo "IP unchanged: $CURRENT"
else
  sed -i "s#$SAVED#$CURRENT#" "$TFVARS"
  echo "IP updated: $SAVED -> $CURRENT"
  echo "Run 'terraform apply' to update the security group."
fi

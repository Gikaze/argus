# Load the server IPs from Terraform into the current terminal
# Usage, from the repository root: source scripts/env.sh
export APP=$(terraform -chdir=terraform output -raw srv_app_public_ip)
export ARGUS=$(terraform -chdir=terraform output -raw srv_argus_public_ip)
export APP_PRIVATE=$(terraform -chdir=terraform output -raw srv_app_private_ip)
export ARGUS_PRIVATE=$(terraform -chdir=terraform output -raw srv_argus_private_ip)
echo "srv-app:   $APP (private $APP_PRIVATE)"
echo "srv-argus: $ARGUS (private $ARGUS_PRIVATE)"

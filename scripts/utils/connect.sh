#!/usr/bin/env bash
# Open an SSH session on a server
# Usage, from the repository root: ./scripts/utils/connect.sh app|argus
set -euo pipefail
source scripts/env.sh > /dev/null

case ${1:-} in
  app)   ssh -i ~/.ssh/argus ubuntu@$APP ;;
  argus) ssh -i ~/.ssh/argus ubuntu@$ARGUS ;;
  *)     echo "Usage: ./scripts/utils/connect.sh app|argus"; exit 1 ;;
esac

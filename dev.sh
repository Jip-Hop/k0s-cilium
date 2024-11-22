#!/bin/bash
set -euo pipefail

KUBE_API_SERVER=https://localhost:7443
KUBECONFIG=$(mktemp -t kubeconfig)

export KUBECONFIG
export COMPOSE_PROJECT_NAME=k0s-development
export COMPOSE_FILE=compose.common.yaml:compose.dev.yaml

# Show the results of the merged compose files:
docker compose config

docker compose up -d

trap 'echo "Cleanup test cluster..." && docker compose down --volumes && rm -f "$KUBECONFIG"' EXIT

while [ ! "$(curl -k -s -o /dev/null -w "%{http_code}" "$KUBE_API_SERVER")" -eq 401 ]; do
    echo "Wait until kube accepts API calls..."
    sleep 1
done

docker exec k0s-development k0s kubeconfig admin >"$KUBECONFIG"
kubectl config set clusters.local.server "$KUBE_API_SERVER"

# cilium status --wait --wait-duration=10m

echo 'Enter interactive shell for debugging with kubectl'
echo "To tear down the $COMPOSE_PROJECT_NAME stack type: exit"
zsh

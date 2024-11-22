#!/bin/busybox sh
set -euo pipefail
umask 077

k0s kubectl create -n gateway-infra secret tls default-cert \
    --key=/run/secrets/tls/tls.key \
    --cert=/run/secrets/tls/tls.crt \
    --dry-run=client \
    -oyaml >/var/lib/k0s/manifests/tls/default-cert.yaml

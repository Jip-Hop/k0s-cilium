#!/bin/busybox sh
set -euo pipefail
umask 077

{
    echo 'About to crete new secret!'

    k0s kubectl create -n gateway-infra secret tls default-cert \
        --key=/run/secrets/tls/tls.key \
        --cert=/run/secrets/tls/tls.crt \
        --dry-run=client \
        -oyaml >/var/lib/k0s/manifests/tls/default-cert.yaml

    echo 'Done creating new secret!'
} &>/proc/1/fd/1

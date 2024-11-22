#!/bin/busybox sh
set -euo pipefail

# Fix mounts for cilium as in: https://github.com/k3d-io/k3d/pull/1268
# TODO: make PR in k0s for this
mount --make-rshared /

# TODO: no need to package? Make docs PR in k0s
# (
#     cd /mnt/charts
#     mkdir -p /tmp/charts
#     chmod 700 /tmp/charts
#     tar zcf gateway-api.tgz gateway-api
#     mv gateway-api.tgz /tmp/charts/gateway-api.tgz
# )

/mnt/scripts/apply_default_cert.sh

k0s controller --disable-components metrics-server \
    --config=/mnt/config/k0s_config.yaml \
    --single \
    --debug=true

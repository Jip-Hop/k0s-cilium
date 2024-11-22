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

# Listen for file modified changes in /run/secrets/tls
# and re-apply the secret
inotifyd /mnt/scripts/apply_default_cert.sh /run/secrets/tls:c &

# Apply the default secret once at startup
/mnt/scripts/apply_default_cert.sh

# Listen for file modified changes in /mnt/config
# and restart k0s with the new config applied
inotifyd /mnt/scripts/restart.sh /mnt/config:c &

while :; do
    k0s controller --single \
        --disable-components metrics-server \
        --config=/mnt/config/k0s_config.yaml \
        --debug=true || break
done

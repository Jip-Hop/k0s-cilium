#!/bin/busybox sh
set -euo pipefail

(
    echo 'About to restart...'
    pkill -f '^k0s controller --single'
) &>/proc/1/fd/1

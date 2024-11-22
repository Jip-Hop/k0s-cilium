#!/bin/busybox sh
set -euo pipefail

{
    echo 'About to restart...'
    printenv
    pkill -fx "$K0S_ENTRYPOINT_CMD"
} &>/proc/1/fd/1

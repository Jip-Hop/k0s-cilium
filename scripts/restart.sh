#!/bin/busybox sh
set -euo pipefail

{
    echo 'About to restart...'
    pkill -fx "$K0S_ENTRYPOINT_CMD"
} &>/proc/1/fd/1

#!/bin/busybox sh
set -euo pipefail

(
    echo "$(date) - About to reboot..."
    reboot
) &>/var/log/restart.log

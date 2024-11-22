#!/bin/bash
set -euo pipefail

ABSOLUTE_SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_PARENT_DIR="$(dirname "$ABSOLUTE_SCRIPT_PATH")"

cd "$SCRIPT_PARENT_DIR"

if [ ! -f tls.key ] || [ ! -f tls.crt ]; then
    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
        -addext basicConstraints=critical,CA:TRUE,pathlen:1 \
        -nodes -keyout tls.key -out tls.crt -subj "/CN=localhost" \
        -addext "subjectAltName=DNS:example.com,DNS:localhost,DNS:*.localhost,IP:127.0.0.1"
else
    echo "Key and/or cert already exist..."
fi

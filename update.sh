#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

IMAGE="latex-toolchain"

echo "Updating $IMAGE..."

docker build \
    --pull \
    --no-cache \
    --tag "$IMAGE" \
    "$SCRIPT_DIR"

echo "Update complete!"
docker image ls "$IMAGE"


#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
IMAGE="latex-toolchain"

echo "Building Docker image: $IMAGE"

docker build \
    --tag "$IMAGE" \
    "$SCRIPT_DIR"

echo "Build complete!"
docker image ls "$IMAGE"


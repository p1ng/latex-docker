#!/usr/bin/env bash
set -euo pipefail

echo "Current Docker disk usage:"
docker system df

echo
echo "This will remove:"
echo "  - Dangling Docker images"
echo "  - Unused Docker build cache"
echo
echo "This affects ALL Docker projects."
echo "Running containers and volumes are preserved."
echo

read -r -p "Continue? [y/N] " ANSWER

if [[ ! "$ANSWER" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

docker image prune --force
docker builder prune --force

echo
echo "Docker disk usage after cleanup:"
docker system df


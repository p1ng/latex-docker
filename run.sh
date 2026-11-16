#!/usr/bin/env bash
set -euo pipefail

IMAGE="latex-toolchain"

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <directory|file.tex> [xelatex|pdflatex|lualatex]"
    exit 1
fi

TARGET="$(realpath -e -- "$1")"
ENGINE="${2:-xelatex}"

case "$ENGINE" in
    xelatex)  MODE="-xelatex" ;;
    pdflatex) MODE="-pdf" ;;
    lualatex) MODE="-lualatex" ;;
    *)
        echo "Unknown LaTeX engine: $ENGINE" >&2
        exit 1
        ;;
esac

if [[ -d "$TARGET" ]]; then
    if [[ $# -eq 2 ]]; then
        echo "Engine selection requires a .tex file." >&2
        exit 1
    fi

    DIRECTORY="$TARGET"
    COMMAND=(/bin/bash)

elif [[ -f "$TARGET" && "$TARGET" == *.tex ]]; then
    DIRECTORY="$(dirname "$TARGET")"
    FILENAME="$(basename "$TARGET")"
    mkdir -p "$DIRECTORY/build"
    COMMAND=(latexmk "$MODE" -interaction=nonstopmode \
             -halt-on-error -outdir=build "./$FILENAME")
else
    echo "Expected a directory or .tex file." >&2
    exit 1
fi

DOCKER_ARGS=(
    --rm
    --network none
    --user "$(id -u):$(id -g)"
    --env HOME=/tmp
    --mount "type=bind,source=$DIRECTORY,target=/work"
    --workdir /work
)

if [[ -d "$TARGET" ]]; then
    DOCKER_ARGS+=(-it)
fi

exec docker run "${DOCKER_ARGS[@]}" "$IMAGE" "${COMMAND[@]}"

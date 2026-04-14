#!/bin/bash
# Build script for Layer 2: simBench Image
# Creates: sim-bench:latest

set -euo pipefail

echo "=========================================="
echo "Building Layer 2: simBench"
echo "=========================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCH_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
source "$REPO_DIR/scripts/lib/image-names.sh"

USERNAME=${1:-$(whoami)}
if [ "$USERNAME" = "--user" ]; then
    USERNAME="${2:-$(whoami)}"
fi

BASE_IMAGE="$(resolve_family_base_image bio "$USERNAME" || true)"

echo "Configuration:"
echo "  Tag: sim-bench:latest (user-agnostic)"
echo "  Base image: ${BASE_IMAGE:-$(family_base_image bio)}"
echo ""

if [ -z "$BASE_IMAGE" ]; then
    echo "❌ Error: Layer 1c ($(family_base_image bio)) not found!"
    echo ""
    echo "Please build Layer 1c first:"
    echo "  cd ../../base-image"
    echo "  ./build.sh --user $USERNAME"
    exit 1
fi

echo "Building sim-bench:latest..."
docker build \
    --build-arg BASE_IMAGE="$BASE_IMAGE" \
    -f "$BENCH_DIR/Dockerfile.layer2" \
    -t "sim-bench:latest" \
    "$BENCH_DIR"

echo ""
echo "✓ Layer 2 (simBench) built successfully!"
echo "  Image: sim-bench:latest"
echo ""
echo "Layer 3 (user personalization) is handled by"
echo "build-layer.sh or scripts/ensure-layer3.sh."

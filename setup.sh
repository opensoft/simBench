#!/bin/bash
# Setup script for simBench - Molecular simulation workbench

set -euo pipefail

USER_NAME="$(whoami)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
LAYER2_IMAGE="sim-bench:latest"
USER_IMAGE="sim-bench:$USER_NAME"

echo "=========================================="
echo "Setting up simBench"
echo "=========================================="
echo ""
echo "Configuration:"
echo "  User: $USER_NAME"
echo "  Layer 2: $LAYER2_IMAGE"
echo "  Layer 3: $USER_IMAGE"
echo ""

if ! docker image inspect "$LAYER2_IMAGE" >/dev/null 2>&1; then
    echo "🔧 sim-bench:latest not found. Building Layer 2..."
    "$SCRIPT_DIR/scripts/build-layer.sh"
else
    echo "✓ Base image '$LAYER2_IMAGE' found"
    echo "🔧 Ensuring user image '$USER_IMAGE'..."
    "$REPO_DIR/scripts/ensure-layer3.sh" --base "$LAYER2_IMAGE" --user "$USER_NAME" --chown /opt/conda
fi

echo ""
echo "✓ simBench setup complete!"
echo "  Open the folder in VS Code and use 'Reopen in Container'."

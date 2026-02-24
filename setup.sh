#!/bin/bash
# Setup script for simBench - Molecular Simulation workbench
# Builds the simBench container image (ESMFold, AlphaFold)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Parse arguments
USERNAME=${1:-$(whoami)}
if [ "$USERNAME" = "--user" ]; then
    USERNAME="${2:-$(whoami)}"
fi

echo "=========================================="
echo "Setting up simBench"
echo "=========================================="
echo ""
echo "Configuration:"
echo "  Username: $USERNAME"
echo ""

# Ensure biobench-base image exists
if ! docker image inspect "biobench-base:$USERNAME" >/dev/null 2>&1; then
    echo "biobench-base:$USERNAME not found. Building base image..."
    if [ -x "$BIO_DIR/setup.sh" ]; then
        "$BIO_DIR/setup.sh" --user "$USERNAME"
    else
        echo "❌ Error: biobench-base:$USERNAME not found and no bioBenches/setup.sh available."
        echo "Please build the bio base image first."
        exit 1
    fi
fi

# Build the simBench image
echo "Building simBench image..."
if [ -f "$SCRIPT_DIR/.devcontainer/docker-compose.yml" ]; then
    docker compose -f "$SCRIPT_DIR/.devcontainer/docker-compose.yml" build
else
    echo "⚠ No docker-compose.yml found. Skipping image build."
    echo "  simBench devcontainer files need to be set up first."
fi

echo ""
echo "✓ simBench setup complete!"
echo "  Open in VS Code with Dev Containers to start working."

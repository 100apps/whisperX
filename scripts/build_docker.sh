#!/bin/bash

# Build Docker images for WhisperX

set -e

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Extract version from pyproject.toml
VERSION=$(grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/')
echo "Version: $VERSION"

echo "Building WhisperX Docker images..."

# Build CPU version
echo "Building CPU version..."
docker build -f Dockerfile.cpu -t whisperx/cpu:$VERSION -t whisperx/cpu:latest .

# Build CUDA12 version
echo "Building CUDA12 version..."
docker build -f Dockerfile.cuda12 -t whisperx/cuda12:$VERSION -t whisperx/cuda12:latest .

echo "Docker images built successfully!"
echo "  - whisperx/cpu:$VERSION (whisperx/cpu:latest)"
echo "  - whisperx/cuda12:$VERSION (whisperx/cuda12:latest)"

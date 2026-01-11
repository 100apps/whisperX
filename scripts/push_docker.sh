#!/bin/bash

# Push Docker images to Docker Hub

set -e

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Extract version from pyproject.toml
VERSION=$(grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/')
echo "Version: $VERSION"

echo "Pushing WhisperX Docker images to Docker Hub..."

# Push CPU version
echo "Pushing CPU version..."
docker push whisperx/cpu:$VERSION
docker push whisperx/cpu:latest

# Push CUDA12 version
echo "Pushing CUDA12 version..."
docker push whisperx/cuda12:$VERSION
docker push whisperx/cuda12:latest

echo "Docker images pushed successfully!"
echo "  - whisperx/cpu:$VERSION"
echo "  - whisperx/cpu:latest"
echo "  - whisperx/cuda12:$VERSION"
echo "  - whisperx/cuda12:latest"

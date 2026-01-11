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

# Get Docker Hub username (use environment variable or detect from docker login)
DOCKER_USER=${DOCKER_HUB_USER:-$(docker info 2>/dev/null | grep Username | awk '{print $2}')}

if [ -z "$DOCKER_USER" ]; then
  echo "Error: Cannot detect Docker Hub username. Please set DOCKER_HUB_USER environment variable or login first."
  exit 1
fi

echo "Docker Hub user: $DOCKER_USER"
echo "Pushing WhisperX Docker images to Docker Hub..."

# Tag and push CPU version
echo "Pushing CPU version..."
docker tag whisperx/cpu:$VERSION $DOCKER_USER/whisperx-cpu:$VERSION
docker tag whisperx/cpu:latest $DOCKER_USER/whisperx-cpu:latest
docker push $DOCKER_USER/whisperx-cpu:$VERSION
docker push $DOCKER_USER/whisperx-cpu:latest

# Tag and push CUDA12 version
echo "Pushing CUDA12 version..."
docker tag whisperx/cuda12:$VERSION $DOCKER_USER/whisperx-cuda12:$VERSION
docker tag whisperx/cuda12:latest $DOCKER_USER/whisperx-cuda12:latest
docker push $DOCKER_USER/whisperx-cuda12:$VERSION
docker push $DOCKER_USER/whisperx-cuda12:latest

echo "Docker images pushed successfully!"
echo "  - $DOCKER_USER/whisperx-cpu:$VERSION"
echo "  - $DOCKER_USER/whisperx-cpu:latest"
echo "  - $DOCKER_USER/whisperx-cuda12:$VERSION"
echo "  - $DOCKER_USER/whisperx-cuda12:latest"

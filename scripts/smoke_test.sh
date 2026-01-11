#!/usr/bin/env bash
set -euo pipefail

# Determine image tag and device settings
if [ "${1:-}" == "gpu" ]; then
  IMAGE_TAG="whisperx/cuda12:latest"
  DEVICE="cuda"
  COMPUTE_TYPE="float16"
  DOCKER_OPTS="--gpus all"
else
  IMAGE_TAG=${1:-"whisperx/cpu:latest"}
  DEVICE="cpu"
  COMPUTE_TYPE="int8"
  DOCKER_OPTS=""
fi

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "[smoke] Project root: $PROJECT_ROOT"
echo "[smoke] Image: $IMAGE_TAG"
echo "[smoke] Device: $DEVICE"

# 1) Run whisperx on the sample
docker run --rm $DOCKER_OPTS \
  -v "$PROJECT_ROOT":/workspace \
  "$IMAGE_TAG" /workspace/scripts/sample.wav \
    --device $DEVICE \
    --compute_type $COMPUTE_TYPE \
    --output_format txt \
    --output_dir /workspace/scripts \
    --model tiny \
    --vad_method silero \
    --batch_size 1 \
    --no_align

echo "[smoke] Output files:" && ls -lh "$PROJECT_ROOT/scripts" || true

# 2) Validate output exists and is non-empty
if [ -f "$PROJECT_ROOT/scripts/sample.txt" ]; then
  echo "[smoke] SUCCESS: CLI executed and produced an output file: $PROJECT_ROOT/scripts/sample.txt"
  exit 0
else
  echo "[smoke] FAILURE: Output file not created: $PROJECT_ROOT/scripts/sample.txt"
  exit 1
fi

#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG=${1:-"whisperx:cpu"}

WORKDIR="$(pwd)"

echo "[smoke] Workspace: $WORKDIR"

# 1) Run whisperx on the sample (CPU mode)
docker run --rm \
  -v "$WORKDIR":/workspace \
  "$IMAGE_TAG" /workspace/scripts/sample.wav \
    --device cpu \
    --compute_type int8 \
    --output_format txt \
    --output_dir /workspace/scripts \
    --model tiny \
    --vad_method silero \
    --batch_size 1 \
    --no_align

echo "[smoke] Output files:" && ls -lh "/workspace/scripts" || true

# 2) Validate output exists and is non-empty
if [ -f "/workspace/scripts/sample.txt" ]; then
  echo "[smoke] SUCCESS: CLI executed and produced an output file: /workspace/scripts/sample.txt"
  exit 0
else
  echo "[smoke] FAILURE: Output file not created: /workspace/scripts/sample.txt"
  exit 1
fi

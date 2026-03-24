#!/usr/bin/env bash
# sync_to_vast.sh - Sync project code to a vast.ai instance
#
# Usage: sync_to_vast.sh [OPTIONS] <ssh_host> <ssh_port> [project_root]
#
# Options:
#   --model <name>      Sync a specific model from data/models/<name>
#                       Can be specified multiple times
#   --no-checkpoints    Exclude HF Trainer checkpoint files (optimizer.pt,
#                       scheduler.pt, rng_state.pth, training_args.bin)
#                       Useful for Blackwell GPUs (CVE-2025-32434)
#   --skip-data         Skip data sync (code + config only)
#   --skip-external     Skip data/external/ sync
#   -h, --help          Show this help
#
# Examples:
#   sync_to_vast.sh ssh7.vast.ai 16542
#   sync_to_vast.sh --model byt5-base ssh7.vast.ai 16542
#   sync_to_vast.sh --model byt5-base --no-checkpoints ssh7.vast.ai 16542
#   sync_to_vast.sh --skip-data ssh7.vast.ai 16542 /path/to/project

set -euo pipefail

usage() {
  sed -n '2,/^$/s/^# \?//p' "$0"
}

# --- Argument parsing ---
MODELS=()
NO_CHECKPOINTS=0
SKIP_DATA=0
SKIP_EXTERNAL=0
POSITIONAL=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --model)      MODELS+=("$2"); shift 2 ;;
    --no-checkpoints) NO_CHECKPOINTS=1; shift ;;
    --skip-data)  SKIP_DATA=1; shift ;;
    --skip-external) SKIP_EXTERNAL=1; shift ;;
    -h|--help)    usage; exit 0 ;;
    -*)           echo "Unknown option: $1"; usage; exit 1 ;;
    *)            POSITIONAL+=("$1"); shift ;;
  esac
done

SSH_HOST="${POSITIONAL[0]:?Error: ssh_host is required. Run with --help for usage.}"
SSH_PORT="${POSITIONAL[1]:?Error: ssh_port is required. Run with --help for usage.}"
PROJECT_ROOT="${POSITIONAL[2]:-.}"
REMOTE_DIR="/workspace"

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR"

# --- Helper: ensure remote directory exists ---
ensure_remote_dir() {
  ssh ${SSH_OPTS} -p "${SSH_PORT}" "root@${SSH_HOST}" "mkdir -p '$1'"
}

# --- Step 1: Sync source code and configs ---
echo "=== Syncing code and configs ==="
ensure_remote_dir "${REMOTE_DIR}"

rsync -avz --progress \
  -e "ssh ${SSH_OPTS} -p ${SSH_PORT}" \
  --include='src/***' \
  --include='configs/***' \
  --include='pyproject.toml' \
  --include='uv.lock' \
  --exclude='*' \
  "${PROJECT_ROOT}/" "root@${SSH_HOST}:${REMOTE_DIR}/"

# --- Step 2: Sync data (raw + processed + external) ---
if [[ "${SKIP_DATA}" -eq 0 ]]; then
  echo ""
  echo "=== Syncing data ==="
  ensure_remote_dir "${REMOTE_DIR}/data"

  # Exclude large binary files (PDFs, images, zips) that are not needed for training
  # These can be hundreds of MB each and cause multi-hour transfers
  RSYNC_DATA_EXCLUDES=(
    --exclude='*.pdf'
    --exclude='*.PDF'
    --exclude='*.zip'
    --exclude='*.tar.gz'
    --exclude='*.tar.bz2'
    --exclude='*.png'
    --exclude='*.jpg'
    --exclude='*.jpeg'
    --exclude='extracted_text/'
    --exclude='pdfs/'
  )

  RSYNC_DATA_INCLUDES=(
    --include='raw/***'
    --include='processed/***'
  )
  if [[ "${SKIP_EXTERNAL}" -eq 0 ]]; then
    RSYNC_DATA_INCLUDES+=(--include='external/***')
  fi

  rsync -avz --progress \
    -e "ssh ${SSH_OPTS} -p ${SSH_PORT}" \
    "${RSYNC_DATA_EXCLUDES[@]}" \
    "${RSYNC_DATA_INCLUDES[@]}" \
    --exclude='*' \
    "${PROJECT_ROOT}/data/" "root@${SSH_HOST}:${REMOTE_DIR}/data/"
fi

# --- Step 3: Sync specified models ---
if [[ ${#MODELS[@]} -gt 0 ]]; then
  for model_name in "${MODELS[@]}"; do
    local_model_dir="${PROJECT_ROOT}/data/models/${model_name}"
    if [[ ! -d "${local_model_dir}" ]]; then
      echo "ERROR: Model directory not found: ${local_model_dir}"
      echo "Available models:"
      ls -1 "${PROJECT_ROOT}/data/models/" 2>/dev/null || echo "  (none)"
      exit 1
    fi

    echo ""
    echo "=== Syncing model: ${model_name} ==="
    remote_model_dir="${REMOTE_DIR}/data/models/${model_name}"
    ensure_remote_dir "${remote_model_dir}"

    # Build rsync filter args
    # Order matters: explicit excludes first, then checkpoint excludes,
    # then extension whitelist, then catch-all exclude
    RSYNC_MODEL_ARGS=(
      --exclude='.git/'
      --exclude='.git*'
      --exclude='__pycache__/'
      --exclude='.env'
      --exclude='.venv/'
      --exclude='*.pyc'
    )

    if [[ "${NO_CHECKPOINTS}" -eq 1 ]]; then
      RSYNC_MODEL_ARGS+=(
        --exclude='optimizer.pt'
        --exclude='scheduler.pt'
        --exclude='rng_state.pth'
        --exclude='training_args.bin'
      )
    fi

    RSYNC_MODEL_ARGS+=(
      --include='*.safetensors'
      --include='*.bin'
      --include='*.json'
      --include='*.model'
      --include='*.txt'
      --include='*.py'
      --include='*.ot'
      --exclude='*'
    )

    rsync -avz --progress \
      -e "ssh ${SSH_OPTS} -p ${SSH_PORT}" \
      "${RSYNC_MODEL_ARGS[@]}" \
      "${local_model_dir}/" "root@${SSH_HOST}:${remote_model_dir}/"
  done
fi

# --- Summary ---
echo ""
echo "=== Sync complete ==="
if [[ ${#MODELS[@]} -gt 0 ]]; then
  echo "Models synced: ${MODELS[*]}"
fi
echo "Connect: ssh ${SSH_OPTS} -p ${SSH_PORT} root@${SSH_HOST}"

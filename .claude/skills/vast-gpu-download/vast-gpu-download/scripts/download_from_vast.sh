#!/usr/bin/env bash
#
# download_from_vast.sh - Download training results from vast.ai instance
#
# Usage:
#   download_from_vast.sh <SSH_HOST> <SSH_PORT> <EXP_NAME> [PROJECT_ROOT]
#
# Example:
#   download_from_vast.sh ssh3.vast.ai 24836 exp032_byt5_base_adafactor
#   download_from_vast.sh ssh3.vast.ai 24836 exp032_byt5_base_adafactor /path/to/project
#
# Downloads:
#   - best_model/ (model weights, config, tokenizer)
#   - Training logs (train_*.txt, train_exp*.log)
#   - Metrics (train_metrics.json, timing.json, config_resolved.json)
#   - Checkpoints are EXCLUDED by default (use --with-checkpoints to include)

set -euo pipefail

# ── Defaults ──────────────────────────────────────────────────────────
SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR"
WITH_CHECKPOINTS=true
DRY_RUN=false
REMOTE_BASE="/workspace/outputs"

# ── Parse flags ───────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-checkpoints)   WITH_CHECKPOINTS=false; shift ;;
        --dry-run)          DRY_RUN=true; shift ;;
        -*)                 echo "Unknown flag: $1" >&2; exit 1 ;;
        *)                  break ;;
    esac
done

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 [--no-checkpoints] [--dry-run] <SSH_HOST> <SSH_PORT> <EXP_NAME> [PROJECT_ROOT]"
    exit 1
fi

SSH_HOST="$1"
SSH_PORT="$2"
EXP_NAME="$3"
PROJECT_ROOT="${4:-$(pwd)}"

LOCAL_DIR="${PROJECT_ROOT}/outputs/${EXP_NAME}"
REMOTE_DIR="${REMOTE_BASE}/${EXP_NAME}"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  vast.ai Result Download                                    ║"
echo "╠══════════════════════════════════════════════════════════════╣"
echo "║  Remote: root@${SSH_HOST}:${SSH_PORT}                       "
echo "║  Experiment: ${EXP_NAME}                                    "
echo "║  Remote path: ${REMOTE_DIR}                                 "
echo "║  Local path: ${LOCAL_DIR}                                   "
echo "║  Checkpoints: ${WITH_CHECKPOINTS}                           "
echo "╚══════════════════════════════════════════════════════════════╝"

# ── Verify remote directory exists ────────────────────────────────────
echo ""
echo "[1/4] Verifying remote directory..."
REMOTE_LS=$(ssh ${SSH_OPTS} -p "${SSH_PORT}" "root@${SSH_HOST}" \
    "ls -la ${REMOTE_DIR}/ 2>&1" || true)

if echo "${REMOTE_LS}" | grep -q "No such file"; then
    echo "ERROR: Remote directory not found: ${REMOTE_DIR}"
    echo "Available experiments:"
    ssh ${SSH_OPTS} -p "${SSH_PORT}" "root@${SSH_HOST}" "ls ${REMOTE_BASE}/ 2>/dev/null" || true
    exit 1
fi

echo "${REMOTE_LS}"

# ── List what will be downloaded ──────────────────────────────────────
echo ""
echo "[2/4] Listing remote files..."
ssh ${SSH_OPTS} -p "${SSH_PORT}" "root@${SSH_HOST}" \
    "du -sh ${REMOTE_DIR}/*/ ${REMOTE_DIR}/*.json ${REMOTE_DIR}/*.txt 2>/dev/null || true"

if [[ "${DRY_RUN}" == true ]]; then
    echo ""
    echo "[DRY RUN] Would download to: ${LOCAL_DIR}"
    exit 0
fi

# ── Create local directory ────────────────────────────────────────────
echo ""
echo "[3/4] Downloading results..."
mkdir -p "${LOCAL_DIR}"

# Build rsync exclude list
EXCLUDES=""
if [[ "${WITH_CHECKPOINTS}" == false ]]; then
    EXCLUDES="--exclude=checkpoint-*/"
fi

# Download everything except checkpoints (by default)
rsync -avz --progress \
    ${EXCLUDES} \
    -e "ssh ${SSH_OPTS} -p ${SSH_PORT}" \
    "root@${SSH_HOST}:${REMOTE_DIR}/" \
    "${LOCAL_DIR}/"

# ── Also grab the main training log from /workspace ───────────────────
echo ""
echo "[4/4] Downloading main training log..."
TRAIN_LOG_PATTERN="train_${EXP_NAME%%_*}*.log"
ssh ${SSH_OPTS} -p "${SSH_PORT}" "root@${SSH_HOST}" \
    "ls /workspace/train_*.log 2>/dev/null" | while read -r logfile; do
    rsync -avz --progress \
        -e "ssh ${SSH_OPTS} -p ${SSH_PORT}" \
        "root@${SSH_HOST}:${logfile}" \
        "${LOCAL_DIR}/" 2>/dev/null || true
done

# ── Rename best_model/ to include CV score ────────────────────────────
if [[ -d "${LOCAL_DIR}/best_model" ]]; then
    echo ""
    echo "[5/5] Renaming best_model with CV score..."

    # Extract best eval_geo_mean from training logs
    BEST_CV=""
    for logfile in "${LOCAL_DIR}"/train_*.txt; do
        [[ -f "${logfile}" ]] || continue
        CV=$(grep -oP "'eval_geo_mean': '[^']*'" "${logfile}" 2>/dev/null \
            | sed "s/'eval_geo_mean': '//;s/'//" \
            | sort -t. -k1,1n -k2,2n | tail -1)
        if [[ -n "${CV}" ]] && [[ -z "${BEST_CV}" || $(echo "${CV} > ${BEST_CV}" | bc -l 2>/dev/null || echo 0) -eq 1 ]]; then
            BEST_CV="${CV}"
        fi
    done

    if [[ -n "${BEST_CV}" ]]; then
        NEW_NAME="cv${BEST_CV}_best_model"
        mv "${LOCAL_DIR}/best_model" "${LOCAL_DIR}/${NEW_NAME}"
        echo "  Renamed: best_model/ -> ${NEW_NAME}/"
    else
        echo "  WARNING: Could not extract CV score. Keeping best_model/ as-is."
    fi
fi

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  Download complete!"
echo "  Local path: ${LOCAL_DIR}"
echo ""
echo "  Contents:"
du -sh "${LOCAL_DIR}"/* 2>/dev/null || true
echo "══════════════════════════════════════════════════════════════"

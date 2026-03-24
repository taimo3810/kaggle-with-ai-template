---
name: vast-gpu-download
description: This skill downloads training results (model weights, training logs, metrics) from a vast.ai GPU instance to the local project. It should be used after remote training completes and BEFORE destroying the instance. Triggers include downloading results, fetching trained model, or collecting training artifacts from vast.ai.
---

# vast.ai Result Download

## Overview

Download all training results from a vast.ai GPU instance to the local `outputs/` directory. This skill ensures no artifacts are lost before instance destruction.

## Critical Rule

**NEVER destroy a vast.ai instance before running this download procedure.** Always download first, verify files locally, then destroy.

## What Gets Downloaded

| Category | Files | Destination |
|----------|-------|-------------|
| Best model | `best_model/` (safetensors, config, tokenizer) | `outputs/<exp>/best_model/` |
| Training logs | `train_*.txt` | `outputs/<exp>/` |
| Main log | `train_*.log` (from `/workspace/`) | `outputs/<exp>/` |
| Metrics | `train_metrics.json`, `timing.json` | `outputs/<exp>/` |
| Config | `config_resolved.json` | `outputs/<exp>/` |
| Checkpoints | `checkpoint-*/` (excluded by default) | `outputs/<exp>/checkpoint-*/` |

## Workflow

### Step 1: Verify Training Completion

Before downloading, confirm training has finished:

```bash
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
    -p <SSH_PORT> root@<SSH_HOST> \
    'ps aux | grep train.py | grep -v grep | wc -l'
```

If the process count is 0, training has completed. Also check for errors:

```bash
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
    -p <SSH_PORT> root@<SSH_HOST> \
    'tail -5 /workspace/train_*.log | tr -cd "[:print:]\n"'
```

### Step 2: Download Results

Run the bundled download script:

```bash
# Standard download (model + logs + metrics, no checkpoints)
scripts/download_from_vast.sh <SSH_HOST> <SSH_PORT> <EXP_NAME> <PROJECT_ROOT>

# Include checkpoints
scripts/download_from_vast.sh --with-checkpoints <SSH_HOST> <SSH_PORT> <EXP_NAME> <PROJECT_ROOT>

# Preview what will be downloaded
scripts/download_from_vast.sh --dry-run <SSH_HOST> <SSH_PORT> <EXP_NAME> <PROJECT_ROOT>
```

Example:
```bash
scripts/download_from_vast.sh ssh3.vast.ai 24836 exp032_byt5_base_adafactor /path/to/project
```

### Step 3: Verify Download

After download, verify the local artifacts:

```bash
ls -lh outputs/<EXP_NAME>/best_model/
ls outputs/<EXP_NAME>/train_*.txt
cat outputs/<EXP_NAME>/train_metrics.json
```

Verify `model.safetensors` is not truncated (should be ~2GB+ for byt5-base).

### Step 4: Destroy Instance

Only after verifying the download, destroy the instance:

```bash
vastai destroy instance <INSTANCE_ID>
```

## Resources

- `scripts/download_from_vast.sh` - Rsync-based result download script

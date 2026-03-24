---
name: vast-gpu-train
description: This skill provisions a vast.ai GPU instance and syncs project code for remote training. It should be used when the user wants to train a model on a remote GPU via vast.ai, including instance creation, code sync, and SSH connection setup.
---

# vast.ai GPU Training Setup

## Overview

Provision a vast.ai GPU instance, sync project code, and prepare for remote model training. Covers instance search, creation, code deployment, and dependency installation.

## Prerequisites

- `vastai` CLI installed and authenticated (`pip install vastai && vastai set api-key <KEY>`)
- SSH key configured (`~/.ssh/id_rsa` or similar)
- `rsync` available locally

## Workflow

### Step 1: Select GPU and Docker Image

Read `references/gpu_compatibility.md` to determine the correct Docker image for the target GPU architecture.

Key mappings:
- **Blackwell** (RTX PRO 6000, RTX 5090, B100, B200): `nvcr.io/nvidia/pytorch:25.01-py3`
- **Ada Lovelace** (RTX 4090, L40S): `pytorch/pytorch:2.6.0-cuda12.4-cudnn9-devel`
- **Hopper** (H100, H200): `pytorch/pytorch:2.6.0-cuda12.4-cudnn9-devel`
- **Ampere** (RTX 3090, A100): `pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel`

### Step 2: Search for Available Instances

```bash
# Search for a specific GPU, sorted by price (cheapest first)
vastai search offers 'gpu_name=RTX_4090 num_gpus=1 reliability>0.95 inet_down>200' -o 'dph+'

# Budget search
vastai search offers 'gpu_ram>=24 num_gpus=1 dph<0.5' -o 'dph+'

# Datacenter (more reliable)
vastai search offers 'gpu_name=RTX_4090 num_gpus=1 datacenter=true' -o 'dph+'
```

Note: GPU names in the API differ from the web UI. See `references/gpu_compatibility.md` for name mappings.

### Step 3: Create Instance

**IMPORTANT — Blackwell Docker image pull time**: The `nvcr.io/nvidia/pytorch:25.01-py3` image is ~20GB. On machines with slow disk I/O or network, the pull can take 10–30+ minutes. Prefer instances with high `inet_down` (>1000 Mbps) and `dlperf` (>200). If an instance takes >10 minutes in "loading" status, consider destroying it and trying another offer.

Use at least `200GB` of disk when creating the instance.

```bash
vastai create instance <OFFER_ID> --image <DOCKER_IMAGE> --disk 200 --ssh
```

Wait for the instance to start, then retrieve connection info:

```bash
vastai show instances --raw | jq '.[] | select(.id == <INSTANCE_ID>) | {id, ssh_host, ssh_port, actual_status}'
```

### Step 4: Sync Code

Use the bundled sync script to deploy project code:

```bash
# Basic: sync code + data (no models)
.claude/skills/vast-gpu-train/scripts/sync_to_vast.sh <SSH_HOST> <SSH_PORT> <PROJECT_ROOT>

# With model weights (only if model exists locally)
.claude/skills/vast-gpu-train/scripts/sync_to_vast.sh --model byt5-base <SSH_HOST> <SSH_PORT> <PROJECT_ROOT>

# Blackwell GPU: exclude checkpoint .pt files (CVE-2025-32434 workaround)
.claude/skills/vast-gpu-train/scripts/sync_to_vast.sh --model byt5-base --no-checkpoints <SSH_HOST> <SSH_PORT>

# Code only (skip data re-sync)
.claude/skills/vast-gpu-train/scripts/sync_to_vast.sh --skip-data <SSH_HOST> <SSH_PORT>

# Multiple models
.claude/skills/vast-gpu-train/scripts/sync_to_vast.sh --model byt5-base --model mrt5-small <SSH_HOST> <SSH_PORT>
```

This syncs `src/`, `configs/`, `data/` (raw CSVs, processed CSVs, external CSVs), `pyproject.toml`, and `uv.lock` to `/workspace` on the remote instance. Model weights are only synced when `--model` is specified.

**IMPORTANT — Large files and rsync**: The sync script excludes PDFs and other large binary files from `data/` to prevent multi-hour transfers. Only CSV files are synced from `data/raw/`, `data/processed/`, and `data/external/`.

**IMPORTANT — Model not available locally**: If the model is not in `data/models/` locally, download it directly on the remote instance instead of syncing (much faster):

```bash
ssh -o StrictHostKeyChecking=no -p <SSH_PORT> root@<SSH_HOST> "pip install huggingface_hub && python3 -c \"
from huggingface_hub import snapshot_download
snapshot_download('<hf_model_id>', local_dir='/workspace/data/models/<model_name>', ignore_patterns=['*.bin', 'rust_model.ot', 'tf_model*', 'flax_model*'])
\""
```

After downloading, convert to safetensors if only `pytorch_model.bin` is available (required for Blackwell GPUs):

```python
import torch
from safetensors.torch import save_file
state_dict = torch.load('pytorch_model.bin', map_location='cpu', weights_only=True)
# Remove shared weight aliases (e.g., T5/mT5 encoder/decoder embed_tokens)
clean = {k: v.contiguous() for k, v in state_dict.items()
         if k not in ('encoder.embed_tokens.weight', 'decoder.embed_tokens.weight')}
save_file(clean, 'model.safetensors')
```

To sync individual files (e.g. updated configs or data):

```bash
scp -o StrictHostKeyChecking=no -P <SSH_PORT> <LOCAL_FILE> root@<SSH_HOST>:/workspace/<REMOTE_PATH>
```

### Step 5: Install Dependencies

SSH into the instance and install required packages:

```bash
ssh -o StrictHostKeyChecking=no -p <SSH_PORT> root@<SSH_HOST>

# On remote:
pip install transformers datasets sacrebleu sentencepiece accelerate safetensors omegaconf scikit-learn
```

For Blackwell GPUs specifically, also handle the transformers CVE-2025-32434 safetensors workaround described in `references/gpu_compatibility.md`.

### Step 6: Verify GPU Access

```bash
python -c "import torch; print(f'CUDA: {torch.cuda.is_available()}, GPU: {torch.cuda.get_device_name(0)}, Capability: {torch.cuda.get_device_capability()}')"
```

## Post-Setup

After setup is complete, training can be launched on the remote instance. Remember to:
- Destroy the instance when training completes: `vastai destroy instance <INSTANCE_ID>`
- Download results before destroying: `scp -P <PORT> root@<HOST>:/workspace/outputs/<path> ./`

## Resources

- `scripts/sync_to_vast.sh` - Rsync-based code sync script
- `references/gpu_compatibility.md` - GPU architecture, Docker image mapping, and known gotchas

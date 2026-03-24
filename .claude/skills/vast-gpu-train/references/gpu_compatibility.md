# GPU Compatibility Reference

## GPU Architecture → Docker Image Mapping

| Architecture | GPUs | Compute Capability | Required Image |
|-------------|------|-------------------|----------------|
| Blackwell | RTX PRO 6000, RTX 5090, B100, B200 | sm_120 (12.0) | `nvcr.io/nvidia/pytorch:25.01-py3` |
| Ada Lovelace | RTX 4090, RTX 4080, L40S, L4 | sm_89 (8.9) | `pytorch/pytorch:2.6.0-cuda12.4-cudnn9-devel` |
| Hopper | H100, H200 | sm_90 (9.0) | `pytorch/pytorch:2.6.0-cuda12.4-cudnn9-devel` |
| Ampere | RTX 3090, A100, A6000 | sm_80-86 | `pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel` |

## Blackwell GPU Gotchas

### 1. PyTorch sm_120 Support
- Standard PyTorch <= 2.6.0 does NOT support sm_120 (Blackwell)
- Only NGC container `nvcr.io/nvidia/pytorch:25.01-py3` (PyTorch 2.6.0a0 + CUDA 12.8) has sm_120 support
- Verify with: `python -c "import torch; print(torch.cuda.get_device_capability())"`
- **WARNING**: The NGC image is ~20GB. Docker pull can take 10–30+ minutes on machines with slow disk/network. Prefer instances with `inet_down > 1000` and `dlperf > 200`. If stuck in "loading" for >10 min, destroy and try another offer.

### 2. transformers CVE-2025-32434 Block
- NGC's PyTorch 2.6.0a0 is treated as < 2.6.0 by transformers
- `torch.load` with `weights_only=False` is blocked for security
- **Solution**: Convert `pytorch_model.bin` to `model.safetensors` (safetensors bypass the CVE check)
- **Checkpoint resume**: HF Trainer checkpoint files (`optimizer.pt`, `scheduler.pt`, `rng_state.pth`, `training_args.bin`) also trigger this block. Use `--no-checkpoints` flag when syncing to exclude them:
  ```bash
  scripts/sync_to_vast.sh --model byt5-base --no-checkpoints <HOST> <PORT>
  ```
  Training will resume from the model weights only (optimizer state is reset).

### 3. safetensors Conversion
```python
import torch
from safetensors.torch import save_file

state_dict = torch.load("pytorch_model.bin", map_location="cpu", weights_only=True)
clean = {k: v.contiguous().clone() for k, v in state_dict.items()}
save_file(clean, "model.safetensors")
```
Note: Some models have shared tensors (e.g., byt5 shared.weight = encoder/decoder embed).
Use `.clone()` to break sharing before saving.

### 4. NGC Image Missing Packages
NGC image does NOT include `transformers`, `datasets`, `sacrebleu`, etc.
Always install dependencies after instance creation.

### 5. Downloading Models Directly on Remote
If the base model is not available locally (not in `data/models/`), download it directly on the remote instance — this is faster than syncing multi-GB files through your local machine:

```bash
ssh -o StrictHostKeyChecking=no -p <PORT> root@<HOST> "pip install huggingface_hub && python3 -c \"
from huggingface_hub import snapshot_download
snapshot_download('google/mt5-large', local_dir='/workspace/data/models/mt5-large',
                  ignore_patterns=['rust_model.ot', 'tf_model*', 'flax_model*'])
\""
```

Then convert `pytorch_model.bin` to `model.safetensors` (required for Blackwell):

```python
import torch
from safetensors.torch import save_file
state_dict = torch.load('pytorch_model.bin', map_location='cpu', weights_only=True)
# For T5/mT5: remove shared tensor aliases to avoid RuntimeError
clean = {k: v.contiguous() for k, v in state_dict.items()
         if k not in ('encoder.embed_tokens.weight', 'decoder.embed_tokens.weight')}
save_file(clean, 'model.safetensors')
```

## vast.ai CLI GPU Name Quirks

GPU names in the API differ from the web UI:
- Web UI: "RTX PRO 6000" → API: `gpu_name=RTX_PRO_6000_S` or `gpu_name=RTX_PRO_6000_WS`
- Web UI: "RTX 4090" → API: `gpu_name=RTX_4090`
- Web UI: "H100" → API: `gpu_name=H100_SXM` or `gpu_name=H100_PCIE`

To discover exact names: `vastai search offers 'gpu_name=RTX gpu_ram>=20' -o 'dph+'`

## vast.ai Instance Types

| Type | `verified` | Description |
|------|-----------|-------------|
| Datacenter (Secure Cloud) | `verified=any` with `datacenter=true` | Reliable, enterprise-grade |
| Community Cloud | `verified=any` with `datacenter=false` | Cheaper, less reliable |

## Recommended Search Queries

```bash
# High-end datacenter GPU, sorted by price
vastai search offers 'gpu_ram>=40 num_gpus=1 datacenter=true reliability>0.95' -o 'dph+'

# Specific GPU model
vastai search offers 'gpu_name=RTX_4090 num_gpus=1 datacenter=true' -o 'dph+'

# Budget option
vastai search offers 'gpu_ram>=24 num_gpus=1 dph<0.5' -o 'dph+'
```

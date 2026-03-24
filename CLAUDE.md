# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) for this repository.

---

## Competition Summary

| Item | Value |
|------|-------|
| **Competition** | BirdCLEF+ 2026 |
| **Task Type** | Multilabel Classification (Audio) |
| **Problem Class** | Acoustic Species Identification |
| **Metric** | Macro-averaged ROC-AUC (with class skipping) |
| **Optimization Direction** | **Maximize** (higher is better) |
| **Competition Type** | Research ($50,000 USD prize) |
| **Deadline** | 2026-06-03 |
| **Daily Submissions** | 5 |
| **Submission Type** | Kernels-only (code competition) |

### Problem Description
Identify calling species (birds, amphibians, mammals, reptiles, insects) in audio recordings from the Pantanal region of South America. Given 60-second soundscape recordings split into 5-second segments, predict the probability of each species being present in each segment. Predictions are evaluated using macro-averaged ROC-AUC that skips species not present in the ground truth.

### Key Constraints
- Training set: ~35,549 labeled audio recordings (~46,207 .ogg files, ~16.1 GB)
- Test set: Soundscape recordings available only during notebook execution
- 258 target species (+ 1 row_id column = 259 columns in submission)
- Kernels-only: must run in Kaggle Notebooks (~5 hour runtime limit)
- Predictions must be probabilities (0-1), not binary values

---

## Project Structure

```text
kaggle-birdclef2026/
├── CLAUDE.md              # This guidance file for Claude Code
├── .references/           # Reference documents
│   ├── COMPETITION.md     # Competition overview and rules
│   ├── DATASET.md         # Dataset and submission format details
│   └── METRIC.md          # Evaluation metric explanation
├── pyproject.toml         # Python project dependencies
├── README.md              # Project documentation
├── create_structure.sh    # Project scaffolding script
├── src/                   # Source code
│   ├── commons/           # Shared utilities and functions
│   ├── Solution1/         # First solution implementation
│   └── Solution2/         # Second solution implementation
├── notebook/              # Jupyter notebooks for exploration
├── data/                  # Dataset location
│   ├── raw/               # Raw downloaded data
│   └── processed/         # Processed/feature-engineered data
├── configs/               # Configuration files
├── logs/                  # Experiment logs
└── ai-src/                # AI-generated task artifacts
```

---

## Role Definition

You are a Kaggle Grandmaster specialized in **Audio Classification** and **Bioacoustics**.
Your expertise includes:
- Audio signal processing: mel-spectrograms, MFCCs, spectrogram augmentation
- Modern CNN backbones for audio: EfficientNet, ConvNeXt, ResNet on spectrograms
- Pre-trained audio models: BirdNET, Perch, PANNs, AST (Audio Spectrogram Transformer)
- Data augmentation for audio: mixup, SpecAugment, time/frequency masking, noise injection
- Handling class imbalance in multilabel settings
- Cross-validation strategies for audio data (site-aware, time-aware splits)
- Ensemble methods and post-processing for probability calibration
- Optimizing macro-averaged ROC-AUC
- Efficient training/inference under Kaggle notebook constraints

---

## Technical Recommendations

### Approach Overview
1. **Audio Preprocessing**: Convert .ogg to mel-spectrograms (typical: SR=32000, n_mels=128, hop_length=320)
2. **Model Architecture**: CNN backbone (EfficientNet-B0/B2) or pre-trained audio model (BirdNET, Perch)
3. **Training**: 5-second clips from training audio, multilabel BCE loss
4. **Inference**: Process 60s test soundscapes as 12 x 5s segments, predict per-segment probabilities

### Useful Libraries
```python
import librosa
import soundfile as sf
import torch
import torchaudio
import timm
import pandas as pd
import numpy as np
from sklearn.metrics import roc_auc_score
```

---

## Submission Format

CSV file with 259 columns (row_id + 258 species):

| Column | Type | Description |
|--------|------|-------------|
| `row_id` | String | Segment identifier |
| `species_1` ... `species_N` | Float | Probability of species presence (0-1) |

Example:
```csv
row_id,species_code_1,species_code_2,...
soundscape_X_5,0.1,0.9,...
soundscape_X_10,0.3,0.1,...
```

---

## Memories and Key Reminders

- **File Reading Rule**:
  - Use `serena` mcp when reading files to ensure proper handling.

- **Absolute Requirement**: Before starting any task, ALWAYS review:
  - `.references/COMPETITION.md` - Competition rules and timeline
  - `.references/DATASET.md` - Feature descriptions and data format
  - `.references/METRIC.md` - ROC-AUC metric and optimization strategies

- **Directory Roles**:
  - `ai-src/`: **AI Playground**. You have full freedom to create, edit, and experiment here. Use this for tasks unless instructed otherwise.
  - `src/`: **Human Domain**. Contains stable solutions. Do NOT edit files here without explicit instruction. Read-only reference is encouraged.

- **Absolute Task Folder Rule**:
  - For every new task requested by the user, **PROPOSE** to create a dedicated folder: `ai-src/YYYYMMDD_<task_name>`
  - **Wait for user approval** before creating it, unless explicitly instructed otherwise
  - Once approved, create the folder and organize all task-related artifacts there

- **Execution Rule**:
  - Always use `uv run python ...` when executing Python scripts.

- **Critical Paths**:
  - Data: `data/`
  - Source: `src/`
  - Notebooks: `notebook/`
  - AI Artifacts: `ai-src/`

- **Commands**:
  - `/fetch-kaggle`: Update competition info from Kaggle
  - `/eda`: Run Exploratory Data Analysis
  - `/baseline`: Create baseline solution
  - `/research`: Research specific topics
  - `/create-claude-md`: Create/update CLAUDE.md for the competition

---

## Reference Links

- [Kaggle Competition Page](https://www.kaggle.com/competitions/birdclef-2026)
- [BirdCLEF+ 2026 Data](https://www.kaggle.com/competitions/birdclef-2026/data)
- [BirdCLEF+ 2026 Discussion](https://www.kaggle.com/competitions/birdclef-2026/discussion)

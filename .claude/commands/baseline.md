---
description: Create baseline model (training & inference code) for the competition
argument-hint: [solution-dir-name]
---

# Create Baseline Model

Create a baseline model and training/inference pipeline for the competition.

**Output Directory:** src/$ARGUMENTS (If argument is empty, use `src/Solution1` as default)

## Context Information

Maximize the use of the following information to select appropriate models and preprocessing.

- @COMPETITION.md
- @DATASET.md
- @METRIC.md

## Instructions

1.  **Understand Task and Data**:
    - Identify the task type (Classification/Regression/etc.) and metric from the provided documents.
    - Select a model (LightGBM/NN/ResNet/BERT/etc.) that fits the dataset characteristics (Numerical/Categorical/Text/Image/etc.).

2.  **Generate Code**:
    Create the following files in the specified directory (Default: `src/Solution1/`):

    *   `train.py`:
        - Load data (pandas, etc.)
        - Basic preprocessing (Imputation, LabelEncoding/OneHotEncoding, etc.)
        - Model training
        - Implementation of Cross Validation (KFold/StratifiedKFold/GroupKFold, etc.)
        - Save model (joblib/pickle/pytorch, etc.)
        - Calculate and display CV score

    *   `inference.py`:
        - Load saved model
        - Preprocessing for test data (same as training)
        - Execute inference
        - Create submission file (`submission.csv`)

3.  **Requirements**:
    - **Fix Seed**: Ensure reproducibility.
    - **Logging**: Properly output training progress and CV scores.
    - **English Comments**: Write code comments in English.
    - **Directory Creation**: Include logic to create necessary directories (`models`, `output`, etc.) if they don't exist.

## Additional Instructions

- Assume data path is under `data/` (Adjust based on `DATASET.md` content).
- Suggest installation commands for necessary libraries (`lightgbm`, `xgboost`, etc.) if needed.

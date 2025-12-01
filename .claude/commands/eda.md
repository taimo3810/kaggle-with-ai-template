---
description: Perform EDA (Exploratory Data Analysis) on the specified file and save results to notebook/eda.ipynb
argument-hint: [target-file-path]
---

# Exploratory Data Analysis (EDA)

Perform EDA on the following data file.

**Target Data:** $ARGUMENTS

## Context Information

Refer to the contents of the following files to understand data meaning and evaluation metrics before analyzing.

- @COMPETITION.md
- @DATASET.md
- @METRIC.md

## Data Directory Structure

- `data/raw/`: Original immutable data
- `data/processed/`: Processed data features

## Instructions

1.  **Generate and Run Python Script**:
    Create and execute Python code to perform the following analyses:
    *   Load data (using pandas)
    *   Check basic statistics (`describe()`, `info()`)
    *   Check for missing values
    *   Visualize distribution of the target variable
    *   Check correlations between main features and target
    *   (If time series) Plot changes over time

2.  **Create Notebook**:
    Summarize the executed analysis code and findings into a Jupyter Notebook file named `notebook/eda.ipynb`.
    *   Describe the analysis intent and interpretation of results in Markdown cells.
    *   Use `matplotlib` or `seaborn` for plotting.
    *   Write in **English**.

## Notes

- If libraries are missing in the execution environment, suggest installation commands.
- If the data size is large, consider sampling for analysis.

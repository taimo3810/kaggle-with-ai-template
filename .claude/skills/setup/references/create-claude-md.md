---
description: Automatically update CLAUDE.md based on current competition info
allowed-tools: Bash(find:*)
argument-hint: []
---

# Update CLAUDE Memory

Read competition info files (`COMPETITION.md`, `DATASET.md`, `METRIC.md`) and analyze current project structure to generate/update the AI assistant context file `CLAUDE.md`.

## Context Information

- @COMPETITION.md
- @DATASET.md
- @METRIC.md
- Current file structure: !`find . -maxdepth 3 -not -path '*/.*'`

## Instructions

1.  **Extract Information**:
    Extract key information from each file:
    - **Competition Name**: (From COMPETITION.md)
    - **Task Type**: (Classification/Regression/Time Series, etc.)
    - **Metric**: (From METRIC.md, including optimization direction)
    - **Data Overview**: (From DATASET.md, important filenames and columns)
    - **Current Project Structure**: Analyze the output of the `find` command above to identify existing directories and key files.

2.  **Create/Update CLAUDE.md**:
    Generate `CLAUDE.md` using the template below.
    Ensure all comments and instructions in `CLAUDE.md` are in **English**.

    ### CLAUDE.md Template

    ```markdown
    # CLAUDE.md

    This file provides guidance to Claude Code (claude.ai/code) for this repository.
    
    ---

    ## Project Structure

    Reflect the **actual** directory structure found in the project.

    ```text
    [Project Root]/
    ├── CLAUDE.md              # This guidance file for Claude Code
    ├── COMPETITION.md         # Competition overview
    ├── DATASET.md             # Dataset details
    ├── METRIC.md              # Metric details
    ├── pyproject.toml         # Python project dependencies
    ├── README.md              # Project documentation
    ├── src/                   # Source code
    │   ├── commons/           # Shared utilities and functions
    │   └── SolutionX/         # Solution implementation
    ├── notebook/              # Jupyter notebooks for exploration
    ├── data/                  # Dataset location
    ├── configs/               # Configuration files
    ├── logs/                  # Experiment logs
    └── ai-src/                # AI-generated task artifacts
    ```

    ---

    ## Role Definition

    You are a Kaggle Grandmaster specialized in [Task Type] and [Key Domain].
    Your expertise includes:
    - [Relevant expertise based on Task Type] (e.g., Modern CNN backbones, Gradient Boosting, Transformers)
    - [Relevant expertise based on Data] (e.g., Data augmentation, Feature engineering)
    - Cross-validation design and ensemble strategies
    - Optimizing competition-specific metrics ([Metric Name])
    - Efficient training/inference under Kaggle constraints

    ---

    ## Memories and Key Reminders

    - **File Reading Rule**:
      - Use `serena` mcp when reading files to ensure proper handling.

    - **Absolute Requirement**: Before starting any task, ALWAYS review:
      - `COMPETITION.md`
      - `DATASET.md`
      - `METRIC.md`

    - **Directory Roles**:
      - `ai-src/`: **AI Playground**. You have full freedom to create, edit, and experiment here. Use this for tasks unless instructed otherwise.
      - `src/`: **Human Domain**. Contains stable solutions. Do NOT edit files here without explicit instruction. Read-only reference is encouraged.

    - **Absolute Task Folder Rule**:
      - For every new task requested by the user, **PROPOSE** to create a dedicated folder: `ai-src/YYYYMMDD_<task_name>`.
      - **Wait for user approval** before creating it, unless explicitly instructed otherwise.
      - Once approved (or if instructed), create the folder and organize all task-related artifacts there.

    - **Execution Rule**:
      - Always use `uv run python ...` when executing Python scripts.

    - **Critical Paths**:
      - Data: `data/`
      - Source: `src/`
      - Notebooks: `notebook/`
      - AI Artifacts: `ai-src/`

    - **Commands**:
      - `/fetch-kaggle`: Update competition info
      - `/research`: Research topics
      - `/eda`: Run EDA
      - `/baseline`: Create baseline
      - `/create-claude-md`: Create/update CLAUDE.md for the competition
    ```

3.  **Execution**:
    Overwrite `CLAUDE.md` with the generated content.

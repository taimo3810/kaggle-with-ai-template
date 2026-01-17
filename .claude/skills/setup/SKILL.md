---
name: setup
description: Initialize project and set up competition environment (all-in-one). Use when starting a new Kaggle/atmaCup competition project or when user invokes /setup.
---

# Project Setup (All-in-One)

## Overview

This skill sets up the entire project for a Kaggle/atmaCup competition in one command. It handles dependency installation, directory creation, competition information fetching, and AI context file generation.

## When to Use

- Starting a new competition project
- User invokes `/setup` or `/setup [competition-url-or-name]`
- Need to initialize project structure for a competition

## Workflow

Execute these 4 steps in order:

### Step 1: Install Dependencies

Run `uv sync` to install all Python dependencies defined in `pyproject.toml`.

```bash
uv sync
```

### Step 2: Create Directory Structure

Create the following directories if they don't exist:

```bash
mkdir -p configs data/raw data/processed src/commons src/Solution1 src/Solution2 ai-src notebook logs
```

### Step 3: Fetch Competition Info

**If a competition URL or name is provided:**

Follow the instructions in `references/fetch-kaggle.md`.

This will create:
- `COMPETITION.md`
- `DATASET.md`
- `METRIC.md`

**If no URL/name is provided:** Skip this step.

### Step 4: Generate CLAUDE.md

**After creating documentation files:**

Follow the instructions in `references/create-claude-md.md`.

This will create/update `CLAUDE.md` with competition-specific context.

## Report Results

After completing all steps, summarize to the user:

| Step | Status |
|------|--------|
| Dependencies installed | ✅ / ❌ |
| Directories created | ✅ / ❌ |
| Competition info fetched | ✅ / ❌ / ⏭️ (skipped if no URL) |
| CLAUDE.md generated | ✅ / ❌ |

## Next Steps Guidance

Provide guidance based on the result:

- **If MCP servers not configured**: Guide user to configure Perplexity/Kaggle MCP
- **If data not downloaded**: Guide user to download competition data
- **Suggest**: Running `/eda` on the training data

## References

This skill includes detailed procedures in `references/`:

- **fetch-kaggle.md**: Complete guide for fetching competition information using agent-browser
- **create-claude-md.md**: Template and instructions for generating CLAUDE.md

## Usage Examples

```bash
# Full setup with Guru Guru Science competition
/setup https://www.guruguru.science/competitions/31

# Full setup with Kaggle competition
/setup titanic

# Basic setup only (no competition specified)
/setup
```

## Notes

- If `uv sync` fails, report the error and suggest solutions.
- Skip creating directories that already exist.
- If no competition URL/name is provided, skip steps 3 and 4.

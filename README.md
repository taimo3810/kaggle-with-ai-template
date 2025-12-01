# Kaggle with AI Template

A template project for efficiently tackling Kaggle competitions using AI.
Leverages Claude Code and MCP (Model Context Protocol) to support everything from competition research to coding.

## Features

- **MCP Integration**: Uses Model Context Protocol to integrate tools.
  - **Perplexity AI**: For searching competition info and research.
  - **Kaggle MCP**: For interacting with Kaggle datasets and competitions.
- **Custom Commands**: Includes Slash Commands for Claude Code (`/fetch-kaggle`, `/create-claude-md`, `/eda`, `/baseline`, etc.)
- **Structured Directories**: Optimized folder structure for experiment management

## Prerequisites

- [Claude Code](https://docs.claude.com/docs/claude-code) installed
- [uv](https://github.com/astral-sh/uv) installed
- Perplexity API Key (for Perplexity MCP server)
- Kaggle API Token (for Kaggle MCP server)

## Setup

1. **Clone & Install**
   Clone the repository or use it as a template.

2. **Install Dependencies**
   Install Python dependencies using uv:
   ```bash
   uv sync
   ```

   To add new dependencies during development, use:
   ```bash
   uv add <package_name>
   ```

3. **Initialize Directories**
   Run the helper script to create the necessary directory structure:
   ```bash
   ./create_structure.sh
   ```

4. **Configure MCP**
   
   This template uses MCP servers to enhance Claude's capabilities. Add the following to your MCP configuration file (e.g., `.mcp.json` or Claude Desktop config).

   ### Perplexity MCP
   Set up with your Perplexity API Key.
   * Note: `PERPLEXITY_API_KEY` environment variable is required in `mcpServers` settings.

   ### Kaggle MCP
   To interact with Kaggle competitions and datasets directly, set up the Kaggle MCP server.
   Please refer to the official [Kaggle MCP Documentation](https://www.kaggle.com/docs/mcp) for installation and configuration instructions.
   
5. **Select Competition**
   Decide which Kaggle competition you want to participate in. You can use the URL or the competition name.

6. **Initialize Competition**
   Run the following commands in Claude Code to start the competition:

   ```bash
   # 1. Fetch competition info (creates COMPETITION.md, etc.)
   /fetch-kaggle [competition-name-or-url]
   # Example: /fetch-kaggle titanic

   # 2. Initialize project memory (creates CLAUDE.md)
   /create-claude-md
   ```

## Directory Structure

The following directory structure is initialized by running `./create_structure.sh`:

- `src/`: **Human-authored code**. Primary solutions and shared utilities reside here. AI should prioritize reading from here and avoid destructive edits unless explicitly instructed.
  - `commons/`: Common utilities
  - `SolutionX/`: Code for each solution
- `ai-src/`: **AI playground**. A dedicated space for AI to freely generate code, run experiments, and store artifacts.
- `notebook/`: Jupyter Notebooks
- `data/`: Datasets (usually ignored by `.gitignore`)
  - `raw/`: Original immutable data
  - `processed/`: Processed data features
- `configs/`: Configuration files
- `logs/`: Experiment logs
- `.claude/commands/`: Custom commands for Claude Code

## Slash Commands for Claude Code

### Fetch Competition Info

Run the following command in Claude Code to research the specified competition (Overview, Dataset, Metric) and automatically generate documentation (`COMPETITION.md`, `DATASET.md`, `METRIC.md`).

```bash
/fetch-kaggle [competition-name-or-url]
```

Example:
```bash
/fetch-kaggle titanic
/fetch-kaggle https://www.kaggle.com/c/house-prices-advanced-regression-techniques
```

> **Note**:
> The `COMPETITION.md`, `DATASET.md`, and `METRIC.md` currently in the repository are examples generated for the **Titanic** competition.
> When using for your own competition, run the `/fetch-kaggle` command to overwrite these files.

### Initialize Project

After fetching competition info, generate the AI assistant's context file `CLAUDE.md`.
This file defines the role, rules, and project structure for the AI.

```bash
/create-claude-md
```

### Exploratory Data Analysis (EDA)

Once the competition overview files are generated, execute EDA on data files and create a Notebook.

```bash
/eda [data-file-path]
```

Example:
```bash
/eda data/train.csv
```

### Research Topics

Research specific topics, papers, or methods relevant to the competition to find improvement ideas.
If executed without arguments, it automatically generates research topics from `COMPETITION.md`.

```bash
/research [topic-or-question]
```

Example:
```bash
/research # Auto-detect topics from COMPETITION.md
/research "SOTA models for 2D bin packing"
/research "Attention mechanism for time series forecasting"
```

### Create Baseline

Create baseline code for training (`train.py`) and inference (`inference.py`) based on competition and dataset info.

```bash
/baseline [solution-name]
```

Example:
```bash
/baseline Solution1
```

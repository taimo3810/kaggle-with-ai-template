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

## Quick Start

1. **Clone & Install**
   Clone the repository or use it as a template.

2. **Run Setup Command**
   In Claude Code, run the setup command with your competition URL:
   ```bash
   /setup [competition-url-or-name]
   ```

   Example:
   ```bash
   /setup https://www.guruguru.science/competitions/31
   /setup titanic
   ```

   This will automatically:
   - Install Python dependencies via `uv sync`
   - Create the necessary directory structure (`src/`, `data/`, `ai-src/`, etc.)
   - Fetch competition info and create `.references/COMPETITION.md`, `.references/DATASET.md`, `.references/METRIC.md`
   - Generate AI context file `CLAUDE.md`

3. **Download Data**
   Download competition data to `data/raw/` directory.

4. **Start Working**
   You're ready to go! Use `/eda` to explore data or `/baseline` to create a baseline solution.

## MCP Configuration (Optional)

This template uses MCP servers to enhance Claude's capabilities. Add the following to your MCP configuration file (e.g., `.mcp.json` or Claude Desktop config).

### Perplexity MCP
Set up with your Perplexity API Key.
* Note: `PERPLEXITY_API_KEY` environment variable is required in `mcpServers` settings.

### Kaggle MCP
To interact with Kaggle competitions and datasets directly, set up the Kaggle MCP server.
Please refer to the official [Kaggle MCP Documentation](https://www.kaggle.com/docs/mcp) for installation and configuration instructions.

## Directory Structure

The following directory structure is initialized by running `/setup`:

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

### Setup (All-in-One)

Set up the entire project for a competition in one command:

```bash
/setup [competition-url-or-name]
```

Example:
```bash
/setup https://www.guruguru.science/competitions/31
/setup titanic
```

### Fetch Competition Info

If you need to update competition info separately:

```bash
/fetch-kaggle [competition-name-or-url]
```

### Update CLAUDE.md

Regenerate the AI assistant's context file:

```bash
/create-claude-md
```

### Exploratory Data Analysis (EDA)

Execute EDA on data files and create a Notebook:

```bash
/eda [data-file-path]
```

Example:
```bash
/eda data/train.csv
```

### Research Topics

Research specific topics, papers, or methods relevant to the competition:

```bash
/research [topic-or-question]
```

Example:
```bash
/research # Auto-detect topics from .references/COMPETITION.md
/research "SOTA models for 2D bin packing"
```

### Create Baseline

Create baseline code for training and inference:

```bash
/baseline [solution-name]
```

Example:
```bash
/baseline Solution1
```

## Adding Dependencies

To add new Python packages during development:

```bash
uv add <package_name>
```

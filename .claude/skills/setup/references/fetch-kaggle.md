---
description: Research competition using Kaggle MCP or agent-browser, and create COMPETITION.md, DATASET.md, METRIC.md
argument-hint: [competition-url-or-name]
---

# Competition Research Setup

Research the specified competition in detail and create reference documentation files.

**Target Competition:** $ARGUMENTS

## Supported Platforms & Methods

| Platform | URL Pattern | Method |
|----------|-------------|--------|
| **Kaggle** | `https://www.kaggle.com/competitions/{name}` or just `{name}` | **Kaggle MCP** (preferred) |
| **Guru Guru Science** | `https://www.guruguru.science/competitions/{id}` | agent-browser |

---

## Method A: Kaggle MCP (Preferred for Kaggle)

If the target is a Kaggle competition, use the Kaggle MCP tools directly:

### 1. Get Competition Metadata

```
mcp__kaggle__get_competition({
  request: { competitionName: "<competition-name>" }
})
```

Extract: title, description, category, reward, deadline, evaluation_metric, max_daily_submissions, max_team_size, is_kernels_submissions_only.

### 2. Get Data Files Summary

```
mcp__kaggle__get_competition_data_files_summary({
  request: { competitionName: "<competition-name>" }
})
```

### 3. List Data Files

```
mcp__kaggle__list_competition_data_files({
  request: { competitionName: "<competition-name>", hasPageSize: true, pageSize: 50 }
})
```

### 4. Search Discussions for Additional Info

```
mcp__kaggle__list_forum_topics({
  request: { hasSearchQuery: true, searchQuery: "<competition-name>", sortBy: "Hot", category: "Competitions" }
})
```

### 5. Create Documentation Files

Based on the gathered information, create:
- `.references/COMPETITION.md` - Competition overview, rules, constraints
- `.references/DATASET.md` - Data structure, features, file descriptions
- `.references/METRIC.md` - Evaluation metric, formula, implementation

> **Rule**: Write **facts only**. Do NOT include opinions, recommendations, or tips.

### 6. Validate with Actual Data

If `data/raw/` exists, cross-check with actual files (same as Method B, Step 7).

Skip to **Step 8** (Update CLAUDE.md).

---

## Method B: agent-browser (For non-Kaggle platforms)

## Instructions

### 1. Authenticate (if needed)

Check if authentication state exists and load it:

```bash
# For Guru Guru Science
agent-browser state load ~/.config/guruguru-auth.json

# For Kaggle
agent-browser state load ~/.config/kaggle-auth.json
```

If state file doesn't exist or login is required, guide the user through manual login:

```bash
# Open login page in headed mode
agent-browser open {login-url} --headed

# User logs in manually, then save state
agent-browser state save ~/.config/{platform}-auth.json
```

### 2. Determine Competition URL

If the user provided a URL, use it directly. Otherwise, construct the URL based on platform:

- Guru Guru Science: `https://www.guruguru.science/competitions/{id}`
- Kaggle: `https://www.kaggle.com/competitions/{competition-name}`

### 3. Gather Competition Overview

Navigate to the competition's **Overview** page:

```bash
# Guru Guru Science
agent-browser open https://www.guruguru.science/competitions/{id}

# Kaggle
agent-browser open https://www.kaggle.com/competitions/{name}/overview
```

```bash
agent-browser wait --load networkidle
agent-browser snapshot
```

Extract:
- Competition title and description
- Problem statement and goal
- Task type (Classification, Regression, etc.)
- Timeline and deadlines
- Prizes (if any)
- Rules and constraints

Use `agent-browser get text @ref` to extract specific content from elements.

### 4. Gather Dataset Information

Navigate to the **Data** page:

```bash
# Guru Guru Science
agent-browser open https://www.guruguru.science/competitions/{id}/data-sources

# Kaggle
agent-browser open https://www.kaggle.com/competitions/{name}/data
```

```bash
agent-browser wait --load networkidle
agent-browser snapshot
```

Extract:
- File list and descriptions
- Column/feature descriptions
- Data size and format
- Any data notes or constraints
- Allowed/Prohibited items (important for atmaCup)

### 5. Gather Evaluation Metric

For Kaggle, navigate to the **Overview/Evaluation** section:

```bash
agent-browser open https://www.kaggle.com/competitions/{name}/overview/evaluation
agent-browser wait --load networkidle
agent-browser snapshot
```

For Guru Guru Science, the metric is usually on the overview page or in the opening ceremony PDF.

Extract:
- Metric name and definition
- Evaluation formula
- Submission format requirements
- Official implementation code (if provided)

### 6. Create Documentation Files

Based on the gathered information, create the following files.

> **Rule**: Write **facts only** in each file. Do NOT include opinions, recommendations, tips, or general approaches.

#### `COMPETITION.md`
- Competition background and goal
- Task type (Classification, Regression, Segmentation, etc.)
- Key constraints and timeline
- Submission limits
- Allowed/Prohibited items

#### `DATASET.md`
- Data structure and role of each file
- Description of main features (columns)
- Data notes (missing values, format, etc.)
- File sizes

#### `METRIC.md`
- Metric name and definition
- Formula (LaTeX format recommended)
- Official implementation code (if provided)

### 7. Validate and Supplement DATASET.md with Actual Data

If `data/raw/` exists, read the actual data files and cross-check against the browser-scraped info:

```python
import pandas as pd, glob, os

for path in glob.glob("data/raw/*.csv"):
    df = pd.read_csv(path)
    print(f"\n=== {os.path.basename(path)} ===")
    print(df.info())
    print(df.describe(include="all"))
    print("Missing values:\n", df.isnull().sum())
```

Use the output to:
- **Correct** any discrepancies between the competition page and the actual data (e.g., column names, data types)
- **Supplement** missing information not on the competition page (e.g., actual missing value counts, real value ranges)

Update `DATASET.md` with the corrected and supplemented facts.

### 8. Update CLAUDE.md

Update the `CLAUDE.md` file with:
- Competition summary
- Role definition appropriate for the task
- Technical recommendations
- Metric implementation code

### 9. Close Browser

```bash
agent-browser close
```

---

## Authentication State Management

### First-time Login (Save State)

```bash
# 1. Open login page in headed mode (browser window visible)
agent-browser open {login-url} --headed

# 2. User manually enters credentials and logs in

# 3. Save authenticated state
mkdir -p ~/.config
agent-browser state save ~/.config/{platform}-auth.json

# 4. Close browser
agent-browser close
```

### Subsequent Sessions (Load State)

```bash
# Load saved state before navigating
agent-browser state load ~/.config/{platform}-auth.json

# Now navigate to protected pages
agent-browser open {protected-url}
```

### State File Locations

| Platform | State File |
|----------|------------|
| Guru Guru Science | `~/.config/guruguru-auth.json` |
| Kaggle | `~/.config/kaggle-auth.json` |

---

## Notes

- **Security**: State files contain session cookies. Do not commit to git or share.
- **Expiration**: State may expire. If pages require login again, re-authenticate and save new state.
- Use `agent-browser screenshot` to capture page content if text extraction is difficult.
- Format each file nicely in Markdown.
- If any page fails to load, retry once before reporting an error.
- For atmaCup competitions, check for opening ceremony PDFs which often contain detailed rules.

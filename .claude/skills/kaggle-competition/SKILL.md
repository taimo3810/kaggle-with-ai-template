---
name: kaggle-competition
description: Get competition metadata, data files, and rules using Kaggle MCP. Use when looking up competition details, searching competitions, or fetching competition data file info.
argument-hint: [competition-name]
---

# Kaggle Competition Info

Fetch and display competition information using the Kaggle MCP server.

**Target:** $ARGUMENTS

## Workflow

### 1. Search or Get Competition

**If a competition name is provided:**

Use `mcp__kaggle__get_competition` to get full metadata:

```
mcp__kaggle__get_competition({
  request: { competitionName: "<competition-name>" }
})
```

This returns: title, description, category, reward, deadline, evaluation_metric, max_daily_submissions, max_team_size, is_kernels_submissions_only, team_count, etc.

**If searching by keyword:**

Use `mcp__kaggle__search_competitions`:

```
mcp__kaggle__search_competitions({
  request: {
    hasSearch: true,
    search: "<keyword>",
    hasPageSize: true,
    pageSize: 10,
    sortBy: "Relevance"
  }
})
```

### 2. Get Data Files Summary

Use `mcp__kaggle__get_competition_data_files_summary`:

```
mcp__kaggle__get_competition_data_files_summary({
  request: { competitionName: "<competition-name>" }
})
```

### 3. List Data Files

Use `mcp__kaggle__list_competition_data_files`:

```
mcp__kaggle__list_competition_data_files({
  request: {
    competitionName: "<competition-name>",
    hasPageSize: true,
    pageSize: 50
  }
})
```

For directory-based listing:

```
mcp__kaggle__list_competition_data_tree_files({
  request: {
    competitionName: "<competition-name>",
    hasPageSize: true,
    pageSize: 50
  }
})
```

### 4. Display Results

Present a summary table:

| Item | Value |
|------|-------|
| **Title** | ... |
| **Category** | ... |
| **Metric** | ... |
| **Deadline** | ... |
| **Prize** | ... |
| **Teams** | ... |
| **Daily Submissions** | ... |
| **Kernels Only** | Yes/No |
| **Data Files** | count + total size |

## Notes

- The `competitionName` is the URL slug (e.g., `birdclef-2026`, not the full title)
- Use `search_competitions` with category filter for browsing:
  - `Featured`, `Research`, `Playground`, `GettingStarted`, `Community`
- Sort options: `Grouped`, `Prize`, `EarliestDeadline`, `NumberOfTeams`, `RecentlyCreated`

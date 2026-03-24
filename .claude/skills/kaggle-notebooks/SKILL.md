---
name: kaggle-notebooks
description: Search, view, save, and run Kaggle notebooks using Kaggle MCP. Use when exploring public notebooks, pushing code to Kaggle, or managing notebook sessions.
argument-hint: [search-term or username/notebook-slug]
---

# Kaggle Notebooks

Manage Kaggle notebooks using the Kaggle MCP server.

**Target:** $ARGUMENTS

## Workflows

### Search Notebooks

```
mcp__kaggle__search_notebooks({
  request: {
    hasSearch: true,
    search: "<search-term>",
    sortBy: "Hotness",
    hasPageSize: true,
    pageSize: 10
  }
})
```

**Search by competition:**

```
mcp__kaggle__search_notebooks({
  request: {
    hasCompetition: true,
    competition: "<competition-name>",
    sortBy: "VoteCount",
    hasPageSize: true,
    pageSize: 10
  }
})
```

**Sort options:** `Hotness`, `VoteCount`, `DateCreated`, `DateRun`, `Relevance`, `CommentCount`, `ViewCount`

**Language filter:** `python`, `r`, `sqlite`, `julia`, `all`

### Get Notebook Info & Code

```
mcp__kaggle__get_notebook_info({
  request: {
    userName: "<owner-username>",
    kernelSlug: "<notebook-slug>"
  }
})
```

Returns metadata (title, language, data sources) and blob (source code).

### Save & Run Notebook

Push local code to Kaggle and execute:

```
mcp__kaggle__save_notebook({
  request: {
    slug: "<username>/<notebook-slug>",
    newTitle: "<Notebook Title>",
    hasText: true,
    text: "<source-code>",
    hasLanguage: true,
    language: "python",
    hasKernelType: true,
    kernelType: "notebook",
    isPrivate: true,
    hasEnableInternet: true,
    enableInternet: false,
    competitionDataSourcesSetter: ["<competition-name>"],
    datasetDataSourcesSetter: ["<owner>/<dataset>"],
    modelDataSourcesSetter: ["<owner>/<model>/<framework>/<variation>"]
  }
})
```

**Machine shapes:** Use `machineShape` parameter (e.g., `"gpu-t4"`, `"gpu-p100"`, `"tpu"`)

### Check Session Status

```
mcp__kaggle__get_notebook_session_status({
  request: {
    userName: "<username>",
    kernelSlug: "<notebook-slug>"
  }
})
```

Status values: `QUEUED`, `RUNNING`, `COMPLETE`, `ERROR`, `CANCEL_REQUESTED`

### Get Output

List output files:

```
mcp__kaggle__list_notebook_session_output({
  request: {
    userName: "<username>",
    kernelSlug: "<notebook-slug>"
  }
})
```

Download output:

```
mcp__kaggle__download_notebook_output({
  request: {
    ownerSlug: "<username>",
    kernelSlug: "<notebook-slug>"
  }
})
```

### List Notebook Files

```
mcp__kaggle__list_notebook_files({
  request: {
    userName: "<username>",
    kernelSlug: "<notebook-slug>"
  }
})
```

### Cancel Session

```
mcp__kaggle__cancel_notebook_session({
  request: { kernelSessionId: <session-id> }
})
```

## Notes

- Notebook slug format: `username/notebook-slug`
- For competition notebooks, attach data sources via `competitionDataSourcesSetter`
- `enableGpu` and `enableTpu` are deprecated; use `machineShape` instead
- `kernelType`: `"notebook"` or `"script"`
- Private notebooks are only visible to the owner

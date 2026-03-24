---
name: kaggle-datasets
description: Search, download, and manage Kaggle datasets using Kaggle MCP. Use when finding datasets, checking file structures, or downloading data.
argument-hint: [search-term or owner/dataset-slug]
---

# Kaggle Datasets

Search, explore, and download datasets using the Kaggle MCP server.

**Target:** $ARGUMENTS

## Workflows

### Search Datasets

```
mcp__kaggle__search_datasets({
  request: {
    hasSearch: true,
    search: "<search-term>",
    sortBy: "Relevance",
    hasPageSize: true,
    pageSize: 10
  }
})
```

**Sort options:** `Hottest`, `Votes`, `Updated`, `Published`, `Relevance`, `Usability`, `DownloadCount`, `NotebookCount`

**File type filter:** `All`, `Csv`, `Sqlite`, `Json`, `BigQuery`, `Parquet`

**Size filter:** `All`, `Small`, `Medium`, `Large`

### Get Dataset Info

```
mcp__kaggle__get_dataset_info({
  request: {
    ownerSlug: "<owner>",
    datasetSlug: "<dataset-slug>"
  }
})
```

Returns: title, description, total_bytes, files, versions, tags, license, usability_rating.

### Get Files Summary (Column Metadata)

```
mcp__kaggle__get_dataset_files_summary({
  request: {
    ownerSlug: "<owner>",
    datasetSlug: "<dataset-slug>"
  }
})
```

### List Files

```
mcp__kaggle__list_dataset_files({
  request: {
    ownerSlug: "<owner>",
    datasetSlug: "<dataset-slug>",
    hasPageSize: true,
    pageSize: 50
  }
})
```

Directory-based listing:

```
mcp__kaggle__list_dataset_tree_files({
  request: {
    ownerSlug: "<owner>",
    datasetSlug: "<dataset-slug>"
  }
})
```

### Download Dataset

**Full dataset:**

```
mcp__kaggle__download_dataset({
  request: {
    ownerSlug: "<owner>",
    datasetSlug: "<dataset-slug>",
    raw: false
  }
})
```

**Single file:**

```
mcp__kaggle__download_dataset({
  request: {
    ownerSlug: "<owner>",
    datasetSlug: "<dataset-slug>",
    hasFileName: true,
    fileName: "<filename>"
  }
})
```

**Specific version:**

```
mcp__kaggle__download_dataset({
  request: {
    ownerSlug: "<owner>",
    datasetSlug: "<dataset-slug>",
    hasDatasetVersionNumber: true,
    datasetVersionNumber: <version>
  }
})
```

### Download Competition Data

**All files:**

```
mcp__kaggle__download_competition_data_files({
  request: { competitionName: "<competition-name>" }
})
```

**Single file:**

```
mcp__kaggle__download_competition_data_file({
  request: {
    competitionName: "<competition-name>",
    fileName: "<filename>"
  }
})
```

### Get Dataset Metadata

```
mcp__kaggle__get_dataset_metadata({
  request: {
    ownerSlug: "<owner>",
    datasetSlug: "<dataset-slug>"
  }
})
```

### Check Processing Status

```
mcp__kaggle__get_dataset_status({
  request: {
    ownerSlug: "<owner>",
    datasetSlug: "<dataset-slug>"
  }
})
```

Status values: `DRAFT`, `PROCESSING`, `READY`, `ERROR`, `DELETED`

## Notes

- Dataset slug format: `owner-slug/dataset-slug` (e.g., `kaggle/titanic`)
- Competition data is separate from regular datasets
- Download returns a redirect URL; use the URL to download the actual file
- After downloading, extract to `data/raw/` directory

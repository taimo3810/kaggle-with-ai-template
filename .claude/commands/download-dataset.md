---
description: Download Kaggle competition dataset and extract to data/raw/
argument-hint: [competition-name]
---

# Download Kaggle Dataset

Download the specified Kaggle competition dataset using **Kaggle MCP tools**.

**Target Competition:** $ARGUMENTS

## Instructions

1. **Download Dataset**: Use `mcp__kaggle__download_competition_data_files` to get the download URL for the competition dataset.

2. **Create Directory**: Ensure `data/raw/` directory exists.

3. **Download and Extract**:
   - Download the zip file from the URL using `curl`
   - Extract the contents to `data/raw/`

4. **Verify**: List the files in `data/raw/` to confirm successful download.

## Example Flow

```bash
# 1. Get download URL via MCP tool
# 2. Download
curl -L -o /tmp/dataset.zip "<download-url>"
# 3. Extract
mkdir -p data/raw
unzip -o /tmp/dataset.zip -d data/raw/
# 4. Verify
ls -la data/raw/
```

## Notes

- If the competition name is not provided, ask the user for it.
- Clean up temporary files after extraction.
- Report the list of downloaded files to the user.

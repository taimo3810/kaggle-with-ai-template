---
name: kaggle-submit
description: Submit to a Kaggle competition (code/notebook submission or file upload). Use when submitting predictions or notebooks to a competition.
argument-hint: [competition-name]
---

# Kaggle Submit

Submit to a Kaggle competition using the Kaggle MCP server.

**Target Competition:** $ARGUMENTS

## Submission Types

### Type A: Code Competition (Notebook Submission)

For kernels-only competitions, submit a saved notebook:

```
mcp__kaggle__create_code_competition_submission({
  request: {
    competitionName: "<competition-name>",
    kernelOwner: "<your-username>",
    kernelSlug: "<notebook-slug>",
    hasKernelVersion: true,
    kernelVersion: <version-number>,
    hasSubmissionDescription: true,
    submissionDescription: "<description>"
  }
})
```

**Prerequisites:**
1. Notebook must be saved on Kaggle first (use `save_notebook`)
2. Competition data sources must be attached to the notebook
3. Notebook must produce output matching submission format

### Type B: File Submission (Upload CSV)

#### Step 1: Get Upload Link

```
mcp__kaggle__start_competition_submission_upload({
  request: {
    hasCompetitionName: true,
    competitionName: "<competition-name>",
    fileName: "submission.csv",
    contentLength: <file-size-bytes>,
    lastModifiedEpochSeconds: <epoch-seconds>
  }
})
```

#### Step 2: Upload File and Submit

```
mcp__kaggle__submit_to_competition({
  request: {
    competitionName: "<competition-name>",
    blobFileTokens: "<token-from-step1>",
    hasSubmissionDescription: true,
    submissionDescription: "<description>"
  }
})
```

### Check Submission Status

After submitting, check the status:

```
mcp__kaggle__get_competition_submission({
  request: { ref: <submission-id> }
})
```

## Workflow for This Project (BirdCLEF+ 2026)

This is a **kernels-only** competition. The workflow is:

1. **Save notebook** to Kaggle using `mcp__kaggle__save_notebook`
2. **Submit** using `mcp__kaggle__create_code_competition_submission`
3. **Monitor** using `mcp__kaggle__get_competition_submission`

## Notes

- Max 5 daily submissions for BirdCLEF+ 2026
- Always include a meaningful `submissionDescription`
- For code competitions, ensure the notebook has:
  - Competition data source attached
  - Internet disabled (if required)
  - GPU/TPU settings matching competition rules
  - Output in correct submission format

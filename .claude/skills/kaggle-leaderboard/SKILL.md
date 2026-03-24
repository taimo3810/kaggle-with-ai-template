---
name: kaggle-leaderboard
description: View and analyze competition leaderboard and submissions using Kaggle MCP. Use when checking rankings, scores, or submission history.
argument-hint: [competition-name]
---

# Kaggle Leaderboard

View competition leaderboard and submission history using the Kaggle MCP server.

**Target Competition:** $ARGUMENTS

## Workflow

### 1. Get Leaderboard

Use `mcp__kaggle__get_competition_leaderboard`:

```
mcp__kaggle__get_competition_leaderboard({
  request: {
    competitionName: "<competition-name>",
    hasPageSize: true,
    pageSize: 20
  }
})
```

To force public leaderboard (even if private is available):

```
mcp__kaggle__get_competition_leaderboard({
  request: {
    competitionName: "<competition-name>",
    hasOverridePublic: true,
    overridePublic: true,
    hasPageSize: true,
    pageSize: 20
  }
})
```

### 2. Download Full Leaderboard

For full analysis:

```
mcp__kaggle__download_competition_leaderboard({
  request: { competitionName: "<competition-name>" }
})
```

### 3. Check Own Submissions

List submissions:

```
mcp__kaggle__search_competition_submissions({
  request: {
    competitionName: "<competition-name>",
    group: "All",
    sortBy: "Date",
    hasPageSize: true,
    pageSize: 20
  }
})
```

Filter options:
- **group**: `All`, `Successful`, `Selected`
- **sortBy**: `Date`, `Name`, `PublicScore`, `PrivateScore`

### 4. Get Submission Detail

```
mcp__kaggle__get_competition_submission({
  request: { ref: <submission-id> }
})
```

Returns: public_score, private_score, status, date, description, error_description.

### 5. Display Results

**Leaderboard Top N:**

| Rank | Team | Score |
|------|------|-------|
| 1 | ... | ... |

**Own Submissions:**

| Date | Description | Public Score | Status |
|------|-------------|-------------|--------|
| ... | ... | ... | ... |

## Notes

- Submission status values: `COMPLETE`, `ERROR`, `CANCELLED`, `STUCK`, `NONE`
- Use pagination (`pageToken`) for large leaderboards
- Private scores are only visible after competition ends

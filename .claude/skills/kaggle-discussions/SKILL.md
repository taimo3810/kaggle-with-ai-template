---
name: kaggle-discussions
description: Browse and search Kaggle discussion forums using Kaggle MCP. Use when looking for tips, solutions, or community insights about competitions or datasets.
argument-hint: [search-term or competition-name]
---

# Kaggle Discussions

Browse and search Kaggle discussions using the Kaggle MCP server.

**Target:** $ARGUMENTS

## Workflows

### List All Forums

```
mcp__kaggle__list_forums({
  request: {}
})
```

### Search Discussion Topics

```
mcp__kaggle__list_forum_topics({
  request: {
    hasSearchQuery: true,
    searchQuery: "<search-term>",
    sortBy: "Hot",
    category: "All"
  }
})
```

**Sort options:** `Hot`, `Top`, `New`, `Recent`, `Active`, `Relevance`

**Category filter:** `All`, `Forums`, `Competitions`, `Datasets`, `CompetitionWriteUps`, `Models`, `Benchmarks`

**Recency filter:** `Last30Days`, `Last7Days`, `Today`

### Browse Competition Discussions

To find discussions for a specific competition, first get the competition's forum ID from `get_competition`, then:

```
mcp__kaggle__list_forum_topics({
  request: {
    hasForumId: true,
    forumId: <forum-id>,
    sortBy: "Hot"
  }
})
```

### Get Topic with Comments

```
mcp__kaggle__get_forum_topic({
  request: {
    forumTopicId: <topic-id>,
    includeComments: true,
    hasInitialPageSize: true,
    initialPageSize: 20
  }
})
```

### Get Forum Details

```
mcp__kaggle__get_forum({
  request: {
    hasForumId: true,
    forumId: <forum-id>,
    forumIdOrSlugCase: "ForumId"
  }
})
```

### Get Competition Write-ups / Solutions

**By topic ID:**

```
mcp__kaggle__get_writeup_by_topic({
  request: { forumTopicId: <topic-id> }
})
```

**By slug:**

```
mcp__kaggle__get_writeup_by_slug({
  request: {
    slug: "<writeup-slug>",
    hasCompetitionName: true,
    competitionName: "<competition-name>",
    slugAssociationCase: "CompetitionName"
  }
})
```

**List hackathon write-ups:**

```
mcp__kaggle__list_hackathon_write_ups({
  request: {
    competitionName: "<competition-name>",
    hasPageSize: true,
    pageSize: 20
  }
})
```

Filter winners only:

```
mcp__kaggle__list_hackathon_write_ups({
  request: {
    competitionName: "<competition-name>",
    hasWinner: true,
    winner: true
  }
})
```

## Typical Use Cases

1. **Competition Research**: Search discussions for a competition to find EDA insights, baseline approaches, and winning solutions
2. **Error Debugging**: Search for common error messages or issues
3. **Solution Mining**: Read write-ups from past competitions for methodology ideas
4. **Community Tips**: Browse hot topics for latest tips and tricks

## Notes

- Forum topics have unique integer IDs
- Use `includeComments: true` to get the full discussion thread
- Write-ups are separate from regular discussion topics
- Competition discussions are linked to competitions via `forumId`

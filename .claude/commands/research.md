---
description: Research a specific topic or generate research queries from COMPETITION.md
argument-hint: [topic-or-question]
---

# Research Topic

Research the specified topic in depth using **Perplexity search tools**.
If the argument is empty, analyze `@COMPETITION.md` to identify key research topics.

**Research Topic:** $ARGUMENTS

## Context Information
- @COMPETITION.md
- @DATASET.md

## Instructions

1.  **Query Formulation (If Argument is Empty)**:
    - Read `@COMPETITION.md` to understand the Problem Type, Goal, and Domain.
    - Identify 3-5 critical research questions (e.g., "SOTA for [Task Type]", "Winning solutions for [Similar Competition]", "Libraries for [Specific Constraint]").
    - **Ask the user** which of these topics to research, or proceed with the most critical one.

2.  **Search & Analyze**:
    Use `perplexity_research` (or available search tools) to investigate the topic (or the generated key topic). Focus on:
    - **Key Concepts/Methods**: What are the standard or state-of-the-art approaches?
    - **Relevant Papers/Articles**: Summarize key findings from authoritative sources (arXiv, Papers with Code, Kaggle Discussions, etc.).
    - **Similar Competitions**: Look for past Kaggle competitions with similar tasks and summarize winning solutions.
    - **Practical Implementation**: Look for existing implementations (GitHub, Kaggle Notebooks) and libraries.

3.  **Report Generation**:
    Output a structured summary in the chat (no file creation required unless asked).
    
    ### Suggested Structure
    - **Executive Summary**: Brief overview.
    - **Key Findings**: detailed explanation of methods/papers.
    - **Relevance to Competition**: How this directly applies to the problem defined in `@COMPETITION.md`.
    - **Pros & Cons**: When to use this vs. alternatives.
    - **Resources**: Links to papers, code, and articles.
    - **Actionable Next Steps**: How to try this in the current project.

## Notes
- Be specific in your search queries to get high-quality technical results.
- If the user provides a URL, summarize the content of that page.

---
description: Research Kaggle competition using Perplexity and create COMPETITION.md, DATASET.md, METRIC.md
argument-hint: [competition-name-or-url]
---

# Kaggle Competition Setup

Research the specified Kaggle competition in detail using **Perplexity search tools (`perplexity_research`, etc.)**.

**Target Competition:** $ARGUMENTS

## Instructions

1.  **Information Gathering**: Search the web for the following points:
    *   **Competition Overview**: Problem statement, background, goal.
    *   **Dataset**: Data types, file structure, column meanings, size, features.
    *   **Metric**: Specific evaluation formula, optimization tips.

2.  **File Creation**: Based on the gathered information, create the following three files in the current directory. Write the content in detail in **English**.

    *   `COMPETITION.md`
        *   Competition background and goal
        *   Task type (Classification, Regression, Segmentation, etc.)
        *   Key constraints

    *   `DATASET.md`
        *   Data structure and role of each file
        *   Description of main features (columns)
        *   Data notes (missing values, imbalance, etc.)

    *   `METRIC.md`
        *   Metric name and definition
        *   Formula (LaTeX format recommended)
        *   General approaches or tips for optimizing this metric

## Notes

*   Ensure to retrieve the latest information.
*   Format each file nicely in Markdown.

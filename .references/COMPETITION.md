# Titanic - Machine Learning from Disaster

## Competition Overview

| Item | Value |
|------|-------|
| **Competition** | Titanic - Machine Learning from Disaster |
| **Task Type** | Binary Classification |
| **Problem Class** | Supervised Learning |
| **Metric** | Accuracy (% of correct predictions) |
| **Optimization Direction** | **Maximize** (higher is better) |
| **Competition Type** | Getting Started (Rolling Leaderboard) |
| **URL** | https://www.kaggle.com/competitions/titanic |

---

## Background and Historical Context

The Kaggle Titanic competition centers on one of history's most notorious maritime disasters—the sinking of the RMS Titanic on April 15, 1912, which resulted in the loss of more than 1,500 lives. This legendary competition exists as a "Getting Started" initiative designed by Kaggle data scientists specifically to introduce newcomers to the platform while providing experienced competitors with a well-studied dataset for benchmarking and learning purposes.

The competition runs indefinitely with a rolling leaderboard, allowing participants to continuously submit predictions and compare their performance against other competitors in the community.

---

## Competition Goal

The fundamental objective is to use machine learning to create a model that predicts which passengers survived the Titanic disaster.

**Task**: Given passenger information (demographics, ticket details, cabin information), predict whether each passenger survived (1) or did not survive (0).

**Input**: Passenger features including:
- Demographics (age, sex)
- Socioeconomic indicators (ticket class, fare)
- Family relationships (siblings/spouses, parents/children aboard)
- Travel information (embarkation port, cabin, ticket number)

**Output**: Binary prediction (0 = did not survive, 1 = survived)

---

## Key Constraints and Rules

### Data Rules
- Participants must accept competition rules before downloading data
- The training dataset contains 891 passengers with known survival outcomes
- The test dataset contains 418 passengers without survival labels
- External data usage is generally permitted but may have specific restrictions

### Submission Rules
- **Daily Submission Limit**: Up to 10 submissions per day (more generous than standard competitions)
- **Submission Format**: CSV file with exactly 2 columns (PassengerId, Survived)
- **Prediction Values**: Must be integers (0 or 1), not probabilities
- **File Size**: Must contain exactly 418 predictions (one per test passenger)

### Leaderboard Rules
- Rolling leaderboard format (no fixed end date)
- Submissions older than 2 months are automatically invalidated
- Teams removed from leaderboard may rejoin with new submissions
- Team size does not affect daily submission limits

### Team Rules
- Each participant starts as a single-person team
- Teams can merge or invite additional members
- Team mergers must occur before any applicable deadlines

---

## Historical Survival Patterns

Understanding the historical context is crucial for feature engineering:

1. **"Women and Children First" Policy**
   - Females: ~74% survival rate
   - Males: ~16% survival rate
   - Children (0-10 years): ~53% survival rate
   - Elderly (60-70 years): ~23% survival rate

2. **Class-Based Disparities**
   - First-class females: ~100% survival
   - Second/Third-class males: ~10% survival
   - First-class passengers had better access to information and lifeboats

3. **Family Dynamics**
   - Passengers with family sizes of 2-4 had higher survival rates
   - Solo travelers and very large families had lower survival rates

---

## Performance Benchmarks

| Approach | Expected Accuracy |
|----------|------------------|
| Random Baseline | ~50% |
| Sex-only Model (all females survive) | ~76.5% |
| Basic Features (sex, class, age) | 77-79% |
| Thoughtful Feature Engineering | 80-81% |
| Advanced Ensemble Methods | 82-84% |
| Top Leaderboard Scores | 83-85% |

**Realistic Target**: ~80% accuracy without excessive optimization

---

## Recommended Approach

### Algorithm Comparison (from research)

| Algorithm | Accuracy | False Discovery Rate |
|-----------|----------|---------------------|
| Logistic Regression | ~93.5% (CV) | 8.6% |
| Decision Tree | ~93.1% (CV) | 9.1% |
| Naïve Bayes | ~91.4% (CV) | 15.5% |
| Random Forest | ~91.9% (CV) | 10.7% |
| XGBoost | 81%+ (Test) | Varies |

*Note: CV accuracy often differs from test set accuracy due to overfitting*

### Recommended Workflow

1. **Exploratory Data Analysis**: Understand feature distributions and survival patterns
2. **Feature Engineering**: Create title extraction, family size, age binning, deck features
3. **Missing Value Handling**: Impute Age (~20% missing), handle Embarked, consider Cabin strategy
4. **Model Training**: Start with Logistic Regression/Decision Trees, progress to ensembles
5. **Cross-Validation**: Use k-fold CV to estimate generalization performance
6. **Hyperparameter Tuning**: Grid search with cross-validation
7. **Submission**: Generate predictions and format according to requirements

---

## Key Success Factors

1. **Feature Engineering > Algorithm Complexity**: Thoughtful feature creation often matters more than sophisticated algorithms
2. **Understand the Domain**: Historical knowledge about the disaster improves predictions
3. **Prevent Overfitting**: High CV accuracy (~95%) often means poor test performance
4. **Validate Properly**: Cross-validation estimates should match test performance
5. **Iterate Systematically**: Use the generous submission limit to test hypotheses

---

## Reference Links

- [Kaggle Competition Page](https://www.kaggle.com/competitions/titanic)
- [Official Titanic Tutorial](https://www.kaggle.com/code/alexisbcook/titanic-tutorial)
- [Getting Started Guide](https://www.kaggle.com/code/alexisbcook/getting-started-with-titanic)
- [Advanced Feature Engineering Tutorial](https://www.kaggle.com/code/gunesevitan/titanic-advanced-feature-engineering-tutorial)

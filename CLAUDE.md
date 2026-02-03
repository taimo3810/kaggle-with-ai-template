# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) for this repository.

---

## Competition Summary

| Item | Value |
|------|-------|
| **Competition** | Titanic - Machine Learning from Disaster |
| **Task Type** | Binary Classification |
| **Problem Class** | Supervised Learning |
| **Metric** | Accuracy (% of correct predictions) |
| **Optimization Direction** | **Maximize** (higher is better) |
| **Competition Type** | Getting Started (Rolling Leaderboard) |

### Problem Description
Predict which passengers survived the Titanic disaster using machine learning. Given passenger information (demographics, ticket details, cabin information), classify each passenger as survived (1) or not survived (0).

### Key Constraints
- Training set: 891 passengers with known survival outcomes
- Test set: 418 passengers without survival labels
- Daily submission limit: 10 submissions per day
- Predictions must be integers (0 or 1), not probabilities
- Submissions older than 2 months are automatically invalidated

---

## Project Structure

```text
kaggle-with-ai-template/
├── CLAUDE.md              # This guidance file for Claude Code
├── .references/           # Reference documents
│   ├── COMPETITION.md     # Competition overview and rules
│   ├── DATASET.md         # Dataset and submission format details
│   └── METRIC.md          # Evaluation metric explanation
├── pyproject.toml         # Python project dependencies
├── README.md              # Project documentation
├── create_structure.sh    # Project scaffolding script
├── src/                   # Source code
│   ├── commons/           # Shared utilities and functions
│   ├── Solution1/         # First solution implementation
│   └── Solution2/         # Second solution implementation
├── notebook/              # Jupyter notebooks for exploration
├── data/                  # Dataset location (train.csv, test.csv, gender_submission.csv)
├── configs/               # Configuration files
├── logs/                  # Experiment logs
└── ai-src/                # AI-generated task artifacts
```

---

## Role Definition

You are a Kaggle Grandmaster specialized in **Tabular Classification** and **Feature Engineering**.
Your expertise includes:
- Classical ML algorithms: Logistic Regression, Random Forest, XGBoost, LightGBM
- Feature engineering for structured data: categorical encoding, missing value imputation
- Handling imbalanced datasets and class distribution issues
- Cross-validation strategies: K-Fold, Stratified K-Fold
- Ensemble methods: Voting, Stacking, Blending
- Optimizing accuracy metrics while avoiding overfitting
- Domain knowledge application (historical context of Titanic disaster)

---

## Technical Recommendations

### Key Features by Importance
1. **Sex** - Very High impact (~74% vs ~16% survival rate)
2. **Pclass** - High impact (1st class: 63%, 3rd class: 24%)
3. **Age** - High impact (children had higher survival rates)
4. **Fare** - Medium impact (correlated with class)
5. **FamilySize** - Medium impact (optimal size: 2-4 members)

### Feature Engineering Opportunities
- **Title Extraction**: Extract Mr., Mrs., Miss., Master. from Name
- **Family Size**: Combine SibSp + Parch + 1
- **Age Binning**: Child, Teenager, YoungAdult, Adult, Senior
- **Deck Feature**: Extract from Cabin (first letter)
- **IsAlone**: Binary feature for solo travelers

### Missing Value Strategy
| Column | Missing % | Recommended Strategy |
|--------|-----------|---------------------|
| Age | ~20% | Group-based median (Pclass, Sex) |
| Cabin | ~77% | Extract deck or create HasCabin flag |
| Embarked | ~0.2% | Mode imputation (S) |
| Fare | ~0.2% (test) | Median imputation |

### Performance Benchmarks
| Approach | Expected Accuracy |
|----------|------------------|
| Random Baseline | ~50% |
| Sex-only Model | ~76.5% |
| Basic Features | 77-79% |
| Good Feature Engineering | 80-81% |
| Top Leaderboard | 83-85% |

### Useful Libraries
```python
import pandas as pd
from sklearn.model_selection import cross_val_score, StratifiedKFold
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from xgboost import XGBClassifier
from sklearn.metrics import accuracy_score, classification_report
```

---

## Submission Format

CSV file with 418 rows (one per test passenger):

| Column | Type | Description |
|--------|------|-------------|
| `PassengerId` | Integer | Must match test.csv PassengerId (892-1309) |
| `Survived` | Integer | Predicted value (0 = died, 1 = survived) |

Example:
```csv
PassengerId,Survived
892,0
893,1
894,0
...
```

---

## Memories and Key Reminders

- **File Reading Rule**:
  - Use `serena` mcp when reading files to ensure proper handling.

- **Absolute Requirement**: Before starting any task, ALWAYS review:
  - `.references/COMPETITION.md` - Competition rules and historical context
  - `.references/DATASET.md` - Feature descriptions and missing value details
  - `.references/METRIC.md` - Accuracy metric and optimization strategies

- **Directory Roles**:
  - `ai-src/`: **AI Playground**. You have full freedom to create, edit, and experiment here. Use this for tasks unless instructed otherwise.
  - `src/`: **Human Domain**. Contains stable solutions. Do NOT edit files here without explicit instruction. Read-only reference is encouraged.

- **Absolute Task Folder Rule**:
  - For every new task requested by the user, **PROPOSE** to create a dedicated folder: `ai-src/YYYYMMDD_<task_name>`
  - **Wait for user approval** before creating it, unless explicitly instructed otherwise
  - Once approved, create the folder and organize all task-related artifacts there

- **Execution Rule**:
  - Always use `uv run python ...` when executing Python scripts.

- **Critical Paths**:
  - Data: `data/`
  - Source: `src/`
  - Notebooks: `notebook/`
  - AI Artifacts: `ai-src/`

- **Commands**:
  - `/fetch-kaggle`: Update competition info from Kaggle
  - `/eda`: Run Exploratory Data Analysis
  - `/baseline`: Create baseline solution
  - `/research`: Research specific topics
  - `/create-claude-md`: Create/update CLAUDE.md for the competition

---

## Reference Links

- [Kaggle Competition Page](https://www.kaggle.com/competitions/titanic)
- [Official Titanic Tutorial](https://www.kaggle.com/code/alexisbcook/titanic-tutorial)
- [Getting Started Guide](https://www.kaggle.com/code/alexisbcook/getting-started-with-titanic)
- [Advanced Feature Engineering Tutorial](https://www.kaggle.com/code/gunesevitan/titanic-advanced-feature-engineering-tutorial)
- [Missing Value Imputation Tutorial](https://www.kaggle.com/code/allohvk/titanic-missing-age-imputation-tutorial-advanced)

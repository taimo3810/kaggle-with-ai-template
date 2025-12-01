# Titanic - Dataset Specification

## Dataset Overview

| Item | Value |
|------|-------|
| **Number of Files** | 3 (train.csv, test.csv, gender_submission.csv) |
| **Training Samples** | 891 passengers |
| **Test Samples** | 418 passengers |
| **Features** | 11 columns (excluding target) |
| **Target Variable** | Survived (binary: 0/1) |

---

## File Structure

### train.csv (Training Dataset)

Contains 891 passengers with known survival outcomes. Used for model training and validation.

| Column | Present | Description |
|--------|---------|-------------|
| PassengerId | Yes | Unique identifier |
| Survived | Yes | Target variable |
| All features | Yes | See feature descriptions below |

### test.csv (Test Dataset)

Contains 418 passengers without survival labels. Used for generating predictions.

| Column | Present | Description |
|--------|---------|-------------|
| PassengerId | Yes | Unique identifier |
| Survived | **No** | Must be predicted |
| All features | Yes | See feature descriptions below |

### gender_submission.csv (Sample Submission)

Example submission file showing the correct format.

```csv
PassengerId,Survived
892,0
893,1
894,0
...
```

---

## Feature Descriptions

### Identifier

| Column | Data Type | Description |
|--------|-----------|-------------|
| **PassengerId** | Integer | Unique identifier for each passenger (892-1309 in test set) |

### Target Variable

| Column | Data Type | Values | Description |
|--------|-----------|--------|-------------|
| **Survived** | Integer | 0, 1 | 0 = Did not survive, 1 = Survived |

### Demographic Features

| Column | Data Type | Values | Description |
|--------|-----------|--------|-------------|
| **Sex** | Categorical | male, female | Biological sex of the passenger |
| **Age** | Float | 0.42-80 | Age in years (fractional for infants < 1 year) |

### Socioeconomic Features

| Column | Data Type | Values | Description |
|--------|-----------|--------|-------------|
| **Pclass** | Integer | 1, 2, 3 | Passenger class (1st, 2nd, 3rd) - proxy for socioeconomic status |
| **Fare** | Float | 0-512.33 | Ticket price paid in British pounds |

### Family Features

| Column | Data Type | Values | Description |
|--------|-----------|--------|-------------|
| **SibSp** | Integer | 0-8 | Number of siblings/spouses aboard |
| **Parch** | Integer | 0-6 | Number of parents/children aboard |

### Travel Features

| Column | Data Type | Values | Description |
|--------|-----------|--------|-------------|
| **Ticket** | String | Various | Ticket number (alphanumeric) |
| **Cabin** | String | Various | Cabin number (first letter indicates deck) |
| **Embarked** | Categorical | C, Q, S | Port of embarkation |

#### Embarkation Ports
- **C** = Cherbourg (France)
- **Q** = Queenstown (Ireland, now Cobh)
- **S** = Southampton (England)

---

## Data Quality Issues

### Missing Values

| Column | Training Set | Test Set | Strategy |
|--------|-------------|----------|----------|
| **Age** | 177 (~20%) | 86 (~21%) | Imputation required (median, mean by group) |
| **Cabin** | 687 (~77%) | 327 (~78%) | Drop or extract deck letter |
| **Embarked** | 2 (~0.2%) | 0 | Mode imputation (S) |
| **Fare** | 0 | 1 (~0.2%) | Median imputation |

### Imputation Strategies

#### Age Imputation
```python
# Option 1: Simple median
df['Age'].fillna(df['Age'].median(), inplace=True)

# Option 2: Gender-specific median
# Male average: ~30.7 years
# Female average: ~27.9 years
df.loc[(df['Age'].isnull()) & (df['Sex'] == 'male'), 'Age'] = 30.7
df.loc[(df['Age'].isnull()) & (df['Sex'] == 'female'), 'Age'] = 27.9

# Option 3: Group by Pclass and Sex
df['Age'] = df.groupby(['Pclass', 'Sex'])['Age'].transform(
    lambda x: x.fillna(x.median())
)
```

#### Cabin Handling
```python
# Option 1: Drop column (77% missing)
df.drop('Cabin', axis=1, inplace=True)

# Option 2: Extract deck letter
df['Deck'] = df['Cabin'].str[0]
df['HasCabin'] = df['Cabin'].notna().astype(int)
```

---

## Feature Engineering Opportunities

### Title Extraction (from Name)

Extract honorific titles from the Name column:

```python
df['Title'] = df['Name'].str.extract(r' ([A-Za-z]+)\.')

# Common titles and their survival rates:
# Mr.      - ~16% survival (adult males)
# Mrs.     - ~79% survival (married females)
# Miss.    - ~70% survival (unmarried females)
# Master.  - ~57% survival (young males)
# Rare titles: Dr., Rev., Col., etc.
```

### Family Size

Combine SibSp and Parch:

```python
df['FamilySize'] = df['SibSp'] + df['Parch'] + 1
df['IsAlone'] = (df['FamilySize'] == 1).astype(int)

# Optimal family size: 2-4 members
# Solo travelers and large families (>4) have lower survival
```

### Age Binning

Convert continuous age to categorical:

```python
bins = [0, 12, 18, 35, 60, 100]
labels = ['Child', 'Teenager', 'YoungAdult', 'Adult', 'Senior']
df['AgeGroup'] = pd.cut(df['Age'], bins=bins, labels=labels)
```

### Fare Binning

Convert fare to ticket class tiers:

```python
df['FareBand'] = pd.qcut(df['Fare'], 4, labels=['Low', 'Medium', 'High', 'VeryHigh'])
```

### Deck Feature

Extract deck from cabin number:

```python
# Deck levels (top to bottom): A, B, C, D, E, F, G
# Higher decks (A, B, C) had better access to lifeboats
df['Deck'] = df['Cabin'].str[0]
```

---

## Data Distribution Summary

### Training Set Class Balance

| Survived | Count | Percentage |
|----------|-------|------------|
| 0 (Died) | 549 | 61.6% |
| 1 (Survived) | 342 | 38.4% |

### Passenger Class Distribution

| Pclass | Count | Survival Rate |
|--------|-------|---------------|
| 1 (First) | 216 | 62.96% |
| 2 (Second) | 184 | 47.28% |
| 3 (Third) | 491 | 24.24% |

### Gender Distribution

| Sex | Count | Survival Rate |
|-----|-------|---------------|
| Male | 577 | 18.89% |
| Female | 314 | 74.20% |

### Embarkation Distribution

| Embarked | Count | Survival Rate |
|----------|-------|---------------|
| S (Southampton) | 644 | 33.70% |
| C (Cherbourg) | 168 | 55.36% |
| Q (Queenstown) | 77 | 38.96% |

---

## Submission Format

### Required Columns

| Column | Data Type | Description |
|--------|-----------|-------------|
| PassengerId | Integer | Must match test.csv PassengerId |
| Survived | Integer | Predicted value (0 or 1) |

### Example Submission

```csv
PassengerId,Survived
892,0
893,1
894,0
895,0
896,1
...
1309,0
```

### Submission Requirements

1. **Exactly 418 rows** (one per test passenger)
2. **Header row required**: `PassengerId,Survived`
3. **Integer predictions only**: 0 or 1 (not probabilities)
4. **No index column**: Use `index=False` when saving

```python
submission = pd.DataFrame({
    'PassengerId': test_df['PassengerId'],
    'Survived': predictions
})
submission.to_csv('submission.csv', index=False)
```

---

## Data Loading Example

```python
import pandas as pd

# Load datasets
train_df = pd.read_csv('train.csv')
test_df = pd.read_csv('test.csv')

# Quick exploration
print(f"Training set shape: {train_df.shape}")
print(f"Test set shape: {test_df.shape}")
print(f"\nMissing values in training set:")
print(train_df.isnull().sum())

# Separate features and target
X = train_df.drop(['Survived', 'PassengerId'], axis=1)
y = train_df['Survived']
```

---

## Reference Links

- [Kaggle Data Page](https://www.kaggle.com/c/titanic/data)
- [Data Dictionary](https://www.kaggle.com/c/titanic/data)
- [Advanced Feature Engineering Tutorial](https://www.kaggle.com/code/gunesevitan/titanic-advanced-feature-engineering-tutorial)
- [Missing Value Imputation Tutorial](https://www.kaggle.com/code/allohvk/titanic-missing-age-imputation-tutorial-advanced)

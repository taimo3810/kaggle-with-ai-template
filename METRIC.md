# Titanic - Evaluation Metric

## Metric Name

**Accuracy** (Classification Accuracy)

---

## Metric Definition

### Basic Concept

Accuracy measures the proportion of correct predictions out of all predictions made. It is the most straightforward classification metric and is appropriate for the Titanic dataset due to its relatively balanced class distribution.

### Formula

$$
\text{Accuracy} = \frac{\text{Number of Correct Predictions}}{\text{Total Number of Predictions}} = \frac{TP + TN}{TP + TN + FP + FN}
$$

Where:
- **TP** (True Positives): Correctly predicted survivors
- **TN** (True Negatives): Correctly predicted non-survivors
- **FP** (False Positives): Incorrectly predicted as survived (actually died)
- **FN** (False Negatives): Incorrectly predicted as died (actually survived)

### Alternative Formulation

$$
\text{Accuracy} = \frac{1}{N} \sum_{i=1}^{N} \mathbb{1}(\hat{y}_i = y_i)
$$

Where:
- $N$ = Total number of predictions (418 for Titanic test set)
- $\hat{y}_i$ = Predicted value for passenger $i$
- $y_i$ = True value for passenger $i$
- $\mathbb{1}(\cdot)$ = Indicator function (1 if condition is true, 0 otherwise)

---

## Interpretation

### Score Range

| Score | Interpretation |
|-------|----------------|
| 0.0 (0%) | All predictions wrong |
| 0.5 (50%) | Random guessing baseline |
| 0.765 (~76.5%) | Sex-only baseline |
| 0.80 (80%) | Good model |
| 0.85 (85%) | Excellent model |
| 1.0 (100%) | Perfect predictions |

### Why Accuracy Works for Titanic

1. **Balanced Classes**: Training set has ~38% survivors vs ~62% non-survivors (not severely imbalanced)
2. **Simple Interpretation**: Easy to understand and communicate
3. **Appropriate Task**: Binary classification with clear success criteria

### Limitations of Accuracy

- Does not differentiate between types of errors (FP vs FN)
- Can be misleading for highly imbalanced datasets
- Does not capture confidence/probability calibration

---

## Leaderboard Scoring

### Public vs Private Leaderboard

| Leaderboard | Description | Purpose |
|-------------|-------------|---------|
| **Public** | Visible during competition | Intermediate feedback |
| **Private** | Hidden until competition end | Final ranking |

For the Titanic "Getting Started" competition:
- Rolling leaderboard format
- Same test set used for both public and private scores
- Submissions older than 2 months are invalidated

### Score Calculation

```python
def calculate_accuracy(y_true, y_pred):
    """
    Calculate accuracy score for Titanic predictions.

    Args:
        y_true: Array of true survival values (0 or 1)
        y_pred: Array of predicted survival values (0 or 1)

    Returns:
        Accuracy as a float between 0 and 1
    """
    correct = sum(1 for true, pred in zip(y_true, y_pred) if true == pred)
    return correct / len(y_true)

# Using scikit-learn
from sklearn.metrics import accuracy_score
accuracy = accuracy_score(y_true, y_pred)
```

---

## Optimization Strategies

### 1. Focus on High-Impact Features

Features ranked by predictive importance:

| Rank | Feature | Impact | Rationale |
|------|---------|--------|-----------|
| 1 | Sex | Very High | ~74% vs ~16% survival rate difference |
| 2 | Pclass | High | First class: 63%, Third class: 24% survival |
| 3 | Age | High | Children had higher survival rates |
| 4 | Fare | Medium | Correlated with class and cabin location |
| 5 | FamilySize | Medium | Optimal size: 2-4 members |

### 2. Handle Missing Values Carefully

Impact of imputation strategies:

```python
# Poor strategy: Drop all rows with missing Age (~20% of data)
# Better strategy: Impute with median/mean

# Best strategy: Group-based imputation
df['Age'] = df.groupby(['Pclass', 'Sex'])['Age'].transform(
    lambda x: x.fillna(x.median())
)
```

### 3. Cross-Validation for Model Selection

Avoid overfitting to training data:

```python
from sklearn.model_selection import cross_val_score

# 5-fold cross-validation
cv_scores = cross_val_score(model, X_train, y_train, cv=5, scoring='accuracy')
print(f"CV Accuracy: {cv_scores.mean():.4f} (+/- {cv_scores.std()*2:.4f})")
```

**Warning**: High CV accuracy (>90%) often indicates overfitting. Target 80-82% CV accuracy for realistic generalization.

### 4. Threshold Optimization

For models outputting probabilities:

```python
from sklearn.metrics import accuracy_score
import numpy as np

# Find optimal threshold (default is 0.5)
thresholds = np.arange(0.3, 0.7, 0.01)
best_threshold = 0.5
best_accuracy = 0

for thresh in thresholds:
    y_pred = (probabilities >= thresh).astype(int)
    acc = accuracy_score(y_val, y_pred)
    if acc > best_accuracy:
        best_accuracy = acc
        best_threshold = thresh
```

### 5. Ensemble Methods

Combine multiple models for improved accuracy:

```python
from sklearn.ensemble import VotingClassifier

# Hard voting (majority vote)
ensemble = VotingClassifier(
    estimators=[
        ('rf', RandomForestClassifier()),
        ('lr', LogisticRegression()),
        ('xgb', XGBClassifier())
    ],
    voting='hard'
)
```

---

## Common Pitfalls

### 1. Overfitting to Training Data

| Symptom | CV Accuracy | Test Accuracy | Problem |
|---------|-------------|---------------|---------|
| Overfitting | 95%+ | 78% | Model memorizes training data |
| Good fit | 80% | 79% | Model generalizes well |

**Solution**: Use regularization, cross-validation, and simpler models.

### 2. Leaderboard Probing

Excessive submissions to optimize for leaderboard score leads to overfitting on the test set.

**Solution**: Trust cross-validation scores; limit submissions to 2-3 per day.

### 3. Ignoring Domain Knowledge

The "women and children first" policy is well-documented historically.

**Solution**: Use domain knowledge to guide feature engineering.

### 4. Data Leakage

Using test set information during training (e.g., imputing with combined train+test statistics).

**Solution**: Fit transformers only on training data.

```python
from sklearn.impute import SimpleImputer

# Correct approach
imputer = SimpleImputer(strategy='median')
imputer.fit(X_train)  # Fit only on training data
X_train = imputer.transform(X_train)
X_test = imputer.transform(X_test)
```

---

## Baseline Benchmarks

### Simple Baselines

| Baseline | Strategy | Expected Accuracy |
|----------|----------|------------------|
| Random | Predict 0 or 1 randomly | ~50% |
| Always 0 | Predict all died | ~62% |
| Sex-only | All females survive | ~76.5% |
| Sex + Pclass | Females in 1st/2nd class survive | ~78% |

### Code for Sex-Only Baseline

```python
# Simple yet effective baseline
def sex_baseline(test_df):
    predictions = (test_df['Sex'] == 'female').astype(int)
    return predictions

# This achieves ~76.5% accuracy!
```

---

## Related Metrics (For Analysis)

While accuracy is the competition metric, these metrics help analyze model performance:

### Confusion Matrix

```python
from sklearn.metrics import confusion_matrix, classification_report

cm = confusion_matrix(y_true, y_pred)
print("Confusion Matrix:")
print(cm)
print("\nClassification Report:")
print(classification_report(y_true, y_pred, target_names=['Died', 'Survived']))
```

### Precision, Recall, F1-Score

| Metric | Formula | Use Case |
|--------|---------|----------|
| Precision | TP / (TP + FP) | When FP is costly |
| Recall | TP / (TP + FN) | When FN is costly |
| F1-Score | 2 * (P * R) / (P + R) | Balanced measure |

### ROC-AUC

For comparing models with different thresholds:

```python
from sklearn.metrics import roc_auc_score

# Requires probability outputs
auc = roc_auc_score(y_true, y_proba)
```

---

## Implementation Example

### Complete Evaluation Pipeline

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report

# Load data
train_df = pd.read_csv('train.csv')

# Prepare features (simplified)
train_df['Sex'] = train_df['Sex'].map({'male': 0, 'female': 1})
train_df['Age'].fillna(train_df['Age'].median(), inplace=True)

features = ['Pclass', 'Sex', 'Age', 'SibSp', 'Parch', 'Fare']
X = train_df[features].fillna(0)
y = train_df['Survived']

# Split for validation
X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)

# Train model
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Evaluate
y_pred = model.predict(X_val)
print(f"Validation Accuracy: {accuracy_score(y_val, y_pred):.4f}")

# Cross-validation
cv_scores = cross_val_score(model, X, y, cv=5, scoring='accuracy')
print(f"CV Accuracy: {cv_scores.mean():.4f} (+/- {cv_scores.std()*2:.4f})")

# Detailed report
print("\nClassification Report:")
print(classification_report(y_val, y_pred, target_names=['Died', 'Survived']))
```

---

## Reference Links

- [Kaggle Evaluation Page](https://www.kaggle.com/c/titanic/overview/evaluation)
- [Scikit-learn Accuracy Score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.accuracy_score.html)
- [Tutorial on ML Metrics](https://www.kaggle.com/code/reighns/tutorial-on-machine-learning-metrics)
- [Overfitting and Underfitting Guide](https://www.kaggle.com/code/carlmcbrideellis/overfitting-and-underfitting-the-titanic)

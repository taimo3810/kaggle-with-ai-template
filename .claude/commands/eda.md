---
description: Perform EDA (Exploratory Data Analysis) on the specified file and save results to notebook/eda.ipynb
argument-hint: [target-file-path]
---

# Exploratory Data Analysis (EDA)

Perform EDA on the following data file using **Codex CLI** for intelligent analysis.

**Target Data:** $ARGUMENTS

## Context Information

Refer to the contents of the following files to understand data meaning and evaluation metrics before analyzing.

- @COMPETITION.md
- @DATASET.md
- @METRIC.md

## Data Directory Structure

- `data/raw/`: Original immutable data
- `data/processed/`: Processed data features

---

## Instructions

### 1. Use Codex for Data Analysis

Execute Codex CLI to perform intelligent EDA:

```bash
codex exec --full-auto --sandbox read-only --cd /Users/taikimori/kaggle-with-ai-template \
  "以下のデータファイルに対してEDA（探索的データ分析）を実行してください: $ARGUMENTS

  分析内容:
  1. データの基本統計量 (describe(), info())
  2. 欠損値の確認と可視化
  3. ターゲット変数の分布
  4. 主要特徴量とターゲットの相関
  5. 画像データの場合はサンプル画像の表示
  6. 座標データの場合は地理的分布の可視化

  結果をnotebook/eda.ipynbに保存してください。"
```

### 2. Alternative: Manual Codex Commands

For specific analyses, use targeted Codex commands:

#### Basic Statistics
```bash
codex exec --full-auto --sandbox read-only --cd /Users/taikimori/kaggle-with-ai-template \
  "data/raw/のCSVファイルを読み込んで基本統計量を出力してください"
```

#### Missing Values Analysis
```bash
codex exec --full-auto --sandbox read-only --cd /Users/taikimori/kaggle-with-ai-template \
  "データの欠損値を分析して可視化してください"
```

#### Geographic Distribution (for location data)
```bash
codex exec --full-auto --sandbox read-only --cd /Users/taikimori/kaggle-with-ai-template \
  "緯度経度データの地理的分布を可視化してください"
```

#### Image Sample Display (for image data)
```bash
codex exec --full-auto --sandbox read-only --cd /Users/taikimori/kaggle-with-ai-template \
  "images/ディレクトリからサンプル画像を10枚表示してください"
```

### 3. Create Notebook

After Codex analysis, ensure the notebook is saved:

```bash
codex exec --full-auto --sandbox read-only --cd /Users/taikimori/kaggle-with-ai-template \
  "これまでの分析をnotebook/eda.ipynbにJupyter Notebook形式でまとめてください。
  - Markdownセルで分析意図と結果の解釈を記述
  - matplotlib/seabornで可視化
  - 英語で記述"
```

---

## Codex Parameters Reference

| Parameter | Description |
|-----------|-------------|
| `--full-auto` | Fully automatic mode |
| `--sandbox read-only` | Read-only sandbox (safe for analysis) |
| `--cd <dir>` | Target project directory |
| `"<request>"` | Request content (Japanese OK) |

---

## Expected EDA Output

### For Tabular Data
- Shape and data types
- Missing value counts and percentages
- Statistical summaries (mean, std, min, max, quartiles)
- Target variable distribution
- Feature correlations heatmap

### For Image Data (atmaCup #23)
- Image count and file sizes
- Sample image grid display
- Image dimension verification
- Mask overlay visualization
- Camera angle distribution

### For Geographic Data
- Coordinate range and distribution
- Map visualization with scatter plot
- Density heatmap
- Scene clustering visualization

---

## Notes

- Codex runs in read-only sandbox mode for safe analysis
- If data size is large, Codex will automatically consider sampling
- Results are saved to `notebook/eda.ipynb`
- For complex visualizations, Codex may generate multiple cells

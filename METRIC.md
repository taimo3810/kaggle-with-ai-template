# Santa 2025 - Evaluation Metric

## Metric Name

**Santa 2025 Metric** (Custom Metric)

## Metric Definition

### Basic Concept

For each problem (n-tree packing problem), calculate a **normalized score**, and sum the scores of all 200 problems.

### Formula

#### Single Problem Score

In a problem of placing n trees, let the side length of the minimal bounding square be $s_n$. The normalized score for that problem is:

$$
\text{Score}_n = \frac{s_n^2}{n}
$$

- $s_n$: Side length of the bounding square in the n-tree problem
- $n$: Number of trees
- $s_n^2$: Area of the bounding square

#### Total Score

The final competition score is the sum of normalized scores for all 200 problems:

$$
\text{Total Score} = \sum_{n=1}^{200} \frac{s_n^2}{n}
$$

### Interpretation of Score

- **Lower score is better** (Minimization problem)
- The score represents the sum of "average occupied area per tree" across all problems
- More efficient packing results in a lower score

## Detailed Explanation of Formula

### Significance of Normalization

Why use $\frac{s^2}{n}$ instead of simple area sum:

1. **Scale Normalization**: Fair comparison between problems with different numbers of trees
2. **Efficiency Evaluation**: Reflects packing efficiency (density)
3. **Balance**: Small-scale and large-scale problems are equally important

### Theoretical Minimum

Assuming the area of a single tree $A_{tree} \approx 0.245625$:

- **Theoretical Lower Bound**: $\frac{s_n^2}{n} \geq A_{tree}$ for each problem (in case of perfect packing efficiency)
- **Actual Minimum**: Will be larger than the theoretical value due to the non-rectangular shape of trees

### Bounding Box Calculation

The side length $s$ of the bounding square is determined as:

$$
s = \max\left(x_{\max} - x_{\min}, y_{\max} - y_{\min}\right)
$$

Where $(x_{\min}, x_{\max}, y_{\min}, y_{\max})$ are the ranges of transformed vertices of all trees.

## Optimization Approach

### Basic Strategy

1. **Minimize Area**: Minimize the side length of the bounding square
2. **Maximize Density**: Minimize voids between trees
3. **Leverage Rotation**: Place trees at optimal angles

### Approach by Problem Scale

#### Small-Scale Problems (n = 1-10)

- **Exhaustive Search** or **Manual Optimization** is possible
- Easier to find near-optimal solutions
- Small impact on the total score (due to small denominator)

$$
\sum_{n=1}^{10} \frac{s_n^2}{n} \approx \text{Small Contribution}
$$

#### Medium-Scale Problems (n = 11-50)

- **Pattern-based approaches** are effective
- Efficient placement patterns like hexagonal packing
- Improvement by local search

#### Large-Scale Problems (n = 51-200)

- **Metaheuristics** are necessary
- Simulated Annealing, Genetic Algorithms, etc.
- Large contribution to the total score

### Score Impact Analysis

Weight of score contribution for problem n (reciprocal effect):

| Problem Number | Weight $\frac{1}{n}$ | Relative Impact |
|----------|-------------------|-----------|
| n=1 | 1.000 | Very High |
| n=10 | 0.100 | High |
| n=50 | 0.020 | Medium |
| n=100 | 0.010 | Low |
| n=200 | 0.005 | Lowest |

**Important**: Since the denominator is small for small-scale problems, improving the side length leads to significant score improvement.

## Optimization Tips

### 1. Rotation Optimization

Optimizing tree rotation angles allows for denser packing:

```
Rotation angles to consider:
- 0°, 90°, 180°, 270° (Cardinal directions)
- 60°, 120° (For hexagonal packing)
- 45°, 135° (For diagonal placement)
- Fine-tuning via continuous optimization
```

### 2. Tiling Patterns

Efficient known patterns:

- **Hexagonal Packing**: Pattern close to densest packing of circles
- **Square Grid**: Simple but less efficient
- **Brick Pattern**: Offset row by row

### 3. Simulated Annealing Parameters

```python
# Recommended initial parameters
initial_temperature = 1.0
cooling_rate = 0.9995
iterations_per_temp = 1000
min_temperature = 0.0001
```

### 4. Collision Avoidance

Efficient collision detection:

```python
from shapely.geometry import Polygon

def check_collision(tree1, tree2):
    poly1 = create_polygon(tree1)
    poly2 = create_polygon(tree2)
    return poly1.intersects(poly2)
```

### 5. Fast Bounding Box Calculation

```python
def compute_bounding_box(trees):
    all_x = []
    all_y = []
    for tree in trees:
        vertices = get_transformed_vertices(tree)
        all_x.extend([v[0] for v in vertices])
        all_y.extend([v[1] for v in vertices])

    width = max(all_x) - min(all_x)
    height = max(all_y) - min(all_y)
    side = max(width, height)
    return side
```

## Priority for Score Improvement

### Effective Approaches (ROI Order)

1. **Optimization of Small-Scale Problems** (n ≤ 20)
   - High score improvement effect due to large weight
   - Exhaustive search and manual adjustment feasible

2. **Pattern Application for Medium-Scale Problems** (20 < n ≤ 100)
   - Discovery of efficient tiling patterns
   - Parameter tuning

3. **Metaheuristics for Large-Scale Problems** (n > 100)
   - Long-running Simulated Annealing
   - Ensemble approaches

### Approaches to Avoid

- Using only simple greedy methods (cannot achieve competitive results)
- Grid-based placement (fails to leverage benefits of continuous coordinates)
- Optimization with fixed rotation (limits degrees of freedom)

## Reference Implementation

### Score Calculation Function

```python
def calculate_total_score(submissions):
    """
    submissions: Dict[int, List[Tree]]
        Mapping of problem number -> List of Trees
    """
    total_score = 0.0

    for n in range(1, 201):
        trees = submissions[n]
        side_length = compute_bounding_box(trees)
        normalized_score = (side_length ** 2) / n
        total_score += normalized_score

    return total_score
```

### Baseline Score Estimation

For completely random placement (Reference value):

$$
\text{Random Baseline} \approx \sum_{n=1}^{200} \frac{(k \cdot \sqrt{n})^2}{n} = k^2 \cdot 200
$$

Where $k$ is a constant dependent on tree size.

## Reference Links

- [Santa 2025 Metric Notebook](https://www.kaggle.com/code/metric/santa-2025-metric)
- [Evaluation Page](https://www.kaggle.com/competitions/santa-2025/overview/evaluation)
- [Discussion Forum](https://www.kaggle.com/competitions/santa-2025/discussion)

# Santa 2025 - Dataset Specification

## Dataset Overview

| Item | Value |
|------|-----|
| Number of files | 1 |
| File format | CSV |
| Total size | Approx. 670KB |
| Number of columns | 4 |

## Geometric Specification of Christmas Trees

### Basic Dimensions

```
Tree Width: 0.7 units
Tree Height: 1.0 units
Trunk Dimensions: 0.2 units
```

### Tree Shape

The Christmas tree is represented as a 2D polygon. Typical shape:

- **Body**: Triangle or tiered triangles (conifer silhouette)
- **Trunk**: Rectangular base

The area of a single tree is approximately **0.245625 square units**.

### Coordinate System

- **Origin**: Center position of the tree (usually top center of the trunk)
- **Coordinate Space**: Continuous 2D plane
- **Unit**: Dimensionless

## Submission File Format

### sample_submission.csv

The submission file consists of the following 4 columns:

| Column Name | Data Type | Description |
|----------|----------|------|
| `problem_tree_index` | String | Composite key of problem number and tree index |
| `x` | Float | X-coordinate of the tree |
| `y` | Float | Y-coordinate of the tree |
| `rotation_angle` | Float | Rotation angle of the tree (in degrees) |

### problem_tree_index Structure

```
{problem_number}_{tree_index}

Example:
1_0    -> 1st tree of the 1-tree problem
5_2    -> 3rd tree of the 5-tree problem (0-indexed)
200_199 -> 200th tree of the 200-tree problem
```

### Data Example

```csv
problem_tree_index,x,y,rotation_angle
1_0,0.5,0.5,0
2_0,0.35,0.5,0
2_1,0.85,0.5,0
3_0,0.35,0.35,0
3_1,0.85,0.35,0
3_2,0.6,0.85,0
...
```

## Problem Structure

### Number of Problems

There are a total of **200 independent optimization problems**:

| Problem Number | Number of Trees | Submission Rows |
|----------|------------|----------|
| 1 | 1 tree | 1 row |
| 2 | 2 trees | 2 rows |
| 3 | 3 trees | 3 rows |
| ... | ... | ... |
| 200 | 200 trees | 200 rows |

**Total Rows**: 1 + 2 + 3 + ... + 200 = **20,100 rows**

### Independence of Each Problem

- Each problem is evaluated independently
- No need to share solutions between problems
- Different algorithms can be used for each problem

## Tree Placement Parameters

### Position Specification (x, y)

- **x-coordinate**: Horizontal position
- **y-coordinate**: Vertical position
- **Coordinate Range**: Dependent on bounding box size (unlimited)
- **Precision**: Floating-point precision (double)

### Rotation Angle (rotation_angle)

- **Unit**: Degrees
- **Range**: 0° to 360° (or any real value)
- **Rotation Center**: Reference point of the tree (center coordinate)
- **Positive Direction**: Counter-clockwise (standard mathematical convention)

### Effect of Rotation

Rotation transforms each vertex coordinate of the tree as follows:

```
x' = x * cos(θ) - y * sin(θ)
y' = x * sin(θ) + y * cos(θ)
```

Where θ is the rotation angle (in radians).

## Data Notes

### Collision Detection

- **Important**: Submitted tree placements are checked for collisions
- If there is an overlap, it may be treated as an invalid solution
- Computational geometry libraries (like Shapely) are useful for collision detection

### Numerical Precision Issues

- Beware of errors due to floating-point arithmetic
- Potential impact on collision detection in boundary cases
- Setting an appropriate tolerance is important

### Bounding Box Calculation

The final bounding box is calculated as follows:

1. Transform all vertices of each tree by rotation and translation
2. Get min/max x-coordinates and min/max y-coordinates of all vertices
3. Side length of square bounding box = max(x_max - x_min, y_max - y_min)

### Scaling Considerations

- Small-scale problems (1-10 trees): Manual optimization is possible
- Medium-scale problems (11-50 trees): Leveraging patterns is effective
- Large-scale problems (51-200 trees): Algorithmic approach is essential

## Visualization and Debugging

### Recommended Tools

- **Matplotlib**: 2D visualization in Python
- **Shapely**: Geometric operations and collision detection
- **Jupyter Notebook**: Interactive development

### Visualization Example

```python
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
import numpy as np

def visualize_packing(trees, bounding_box_size):
    fig, ax = plt.subplots(1, 1, figsize=(8, 8))

    for tree in trees:
        # Draw tree polygon
        polygon = create_tree_polygon(tree.x, tree.y, tree.rotation)
        patch = Polygon(polygon, fill=True, alpha=0.5, edgecolor='green')
        ax.add_patch(patch)

    # Draw bounding box
    ax.set_xlim(0, bounding_box_size)
    ax.set_ylim(0, bounding_box_size)
    ax.set_aspect('equal')
    plt.show()
```

## Reference Implementations

Starter notebooks available on Kaggle:

- [Santa 2025 Getting Started](https://www.kaggle.com/code/inversion/santa-2025-getting-started)
- [Santa 2025 Metric](https://www.kaggle.com/code/metric/santa-2025-metric)
- [Deterministic Tiling](https://www.kaggle.com/code/dedquoc/santa-2025-ctpc-deterministic-tiling)
- [Extra Trees Handling](https://www.kaggle.com/code/armanzhalgasbayev/ctpc-extra-trees-handling-santa-2025)

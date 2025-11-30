# Santa 2025 - Christmas Tree Packing Challenge

## Competition Overview

**Organizer**: Kaggle
**Category**: Featured
**Prize Pool**: $50,000 USD
**Start Date**: November 17, 2025
**Entry Deadline**: January 23, 2026
**Final Deadline**: January 30, 2026
**Participants**: 1,141+ teams
**Max Submissions Per Day**: 100
**Max Team Size**: 5

## Background and Goal

### Problem Setting

A festive twist on the classic optimization problem: "How many Christmas trees can fit in a box?"

Santa Claus needs to mail Christmas tree toys to customers around the world. To minimize shipping costs, the trees must be packed into the smallest possible square box. Participants aim to find the optimal packing solution to place from 1 to 200 Christmas trees into their respective minimal square bounding boxes.

### Background

This is a **2D Geometric Optimization Problem** with real-world applications:

- **Logistics Efficiency**: Minimizing packaging size to reduce shipping costs
- **Manufacturing**: Optimizing material cutting efficiency
- **Warehouse Management**: Optimal utilization of storage space

## Task Type

**Variant of 2D Bin Packing Problem**

- **Problem Class**: NP-hard
- **Optimization Type**: Continuous optimization (position and rotation)
- **Constrained Optimization**: With collision avoidance constraints

### Specific Task

1. **Input**: 1 to 200 identically shaped Christmas trees
2. **Output**: Position (x, y coordinates) and rotation angle for each tree
3. **Goal**: Find the smallest square bounding box containing all trees
4. **Scale**: Solve 200 independent optimization problems, ranging from 1 to 200 trees

## Key Constraints

### Geometric Constraints

- **Tree Shape**: All trees have identical shape and size
- **2D Problem**: Placement on a 2D plane, not 3D
- **Square Boundary**: Must fit into a square box, not a rectangle
- **Rotatable**: Each tree can be rotated at any angle

### Placement Constraints

- **Non-overlapping**: Trees must not overlap
- **Within Boundary**: All trees must fit completely within the square boundary
- **Continuous Coordinates**: Placement in a continuous coordinate space, not grid-based

### Competition Rules

- **Submission Format**: CSV format specifying position and rotation for each tree
- **Submission Limit**: Max 100 per day
- **Team**: Max 5 members
- **Code Sharing**: Sharing simple reproduction code for high-scoring submissions is prohibited

## Prizes

| Rank | Prize |
|------|------|
| 1st | $12,000 |
| 2nd | $10,000 |
| 3rd | $10,000 |
| 4th | $8,000 |
| **Rudolph Prize** | $10,000 |

**Rudolph Prize**: A special prize awarded to the participant who holds the 1st place on the leaderboard for the longest duration during the competition.

## Recommended Approaches

### Algorithmic Approaches

1. **Simulated Annealing**
   - Capable of escaping local optima
   - Suitable for continuous optimization

2. **Deterministic Tiling**
   - Utilize known efficient patterns like hexagonal packing
   - Effective for large-scale placements

3. **Genetic Algorithm**
   - Explores diverse solutions
   - Suitable for combinatorial optimization

4. **Greedy + Improvement**
   - Use as a basic baseline
   - Difficult to achieve competitive results alone

### Technical Considerations

- **Collision Detection**: Efficient polygon collision detection algorithm required
- **Numerical Precision**: Watch out for floating-point precision
- **Scalability**: Algorithm design that works effectively from 1 to 200 trees

## Reference Links

- [Kaggle Competition Page](https://www.kaggle.com/competitions/santa-2025)
- [Getting Started Notebook](https://www.kaggle.com/code/inversion/santa-2025-getting-started)
- [Evaluation Metric](https://www.kaggle.com/code/metric/santa-2025-metric)

# Zebra Puzzle - AC-3 Solver

This directory contains implementations and validation for the "Trivial Zebra Puzzle" using constraint satisfaction techniques.

## Files

- **`trival-zebra.md`** - Problem statement describing the puzzle setup, clues, and question
- **`zebra_puzzle_ac3.ipynb`** - Jupyter notebook implementing an AC-3 (Arc Consistency 3) solver
- **`zebra_puzzle_graph.cypher`** - Cypher script representing the initial constraint graph for Neo4j
- **`VALIDATION_REPORT.md`** - Comprehensive validation report of both implementations
- **`test_solver.py`** - Automated test script to validate the Python solver

## The Problem

Three houses in a row, each with a unique color and animal. Given five clues, determine which house the Zebra lives in.

**Clues:**
1. The Cat lives in the Red House.
2. The Red House is the middle house.
3. The Blue House is directly to the left of the Red House.
4. The Dog lives in the Blue House.
5. The Zebra lives in the remaining house.

**Solution:** The Zebra lives in house 3.

## Running the Solver

### Using the Jupyter Notebook

```bash
jupyter notebook zebra_puzzle_ac3.ipynb
```

### Using the Test Script

```bash
python3 test_solver.py
```

This will:
- Extract code from the Jupyter notebook
- Run the AC-3 solver
- Verify the solution against all clues
- Report validation results

## Validation

The implementations have been validated to ensure:

✅ **Python Solver (AC-3):**
- Correctly implements the AC-3 algorithm
- Properly models all constraints from the problem
- Produces the correct solution
- Maintains arc consistency

✅ **Cypher Script:**
- Accurately represents the initial constraint graph state
- All variables start with full domains (houses 1, 2, 3)
- All five clues are represented as explicit constraints
- Includes proper all-different constraints

See `VALIDATION_REPORT.md` for detailed validation results.

## Algorithm Overview

The AC-3 (Arc Consistency Algorithm 3) solver works by:

1. **Initialization:** Each variable (color and animal) starts with a domain of all possible houses {1, 2, 3}
2. **Constraint Propagation:** Binary constraints between variables are enforced through arc consistency
3. **Domain Reduction:** Values that don't satisfy constraints are removed from domains
4. **Solution:** When each domain has exactly one value, the puzzle is solved

## Cypher Graph Model

The Cypher script models the puzzle as a graph with:

- **Nodes:** Houses (pos: 1-3), Colors, Animals
- **Relationships:**
  - `DOMAIN` - Initial possible assignments
  - `MUST_BE` - Unary constraints
  - `SAME_HOUSE_AS` - Equality constraints
  - `LEFT_OF` / `RIGHT_OF` - Spatial constraints
  - `DIFFERENT_HOUSE_FROM` - All-different constraints

This graph structure can be loaded into Neo4j and used for constraint-based reasoning.

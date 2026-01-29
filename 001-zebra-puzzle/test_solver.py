#!/usr/bin/env python3
"""
Test script for the Zebra Puzzle AC-3 Solver

This script extracts the code from the Jupyter notebook and runs it
to verify that the solver produces the correct solution.
"""

import json
import sys

def extract_and_run_solver():
    """Extract code from notebook and run the solver"""
    
    # Read the notebook
    notebook_path = 'zebra_puzzle_ac3.ipynb'
    try:
        with open(notebook_path, 'r') as f:
            nb = json.load(f)
    except FileNotFoundError:
        print(f"Error: Could not find {notebook_path}")
        return False
    
    # Extract and execute code cells
    print("Extracting code from notebook...")
    
    # We'll run the code in a local namespace
    # Note: Using exec() here is safe because the notebook is part of the trusted codebase
    namespace = {}
    
    for i, cell in enumerate(nb['cells']):
        if cell['cell_type'] == 'code':
            code = ''.join(cell['source'])
            try:
                exec(code, namespace)
            except Exception as e:
                print(f"Error executing cell {i}: {e}")
                return False
    
    # Get the domains from the namespace
    domains = namespace.get('domains')
    if not domains:
        print("Error: Could not extract domains from notebook execution")
        return False
    
    # Validate the solution
    print("\nSolution found:")
    print("-" * 40)
    for var in ['Red', 'Blue', 'Green', 'Cat', 'Dog', 'Zebra']:
        if var in domains and domains[var]:
            house = next(iter(domains[var]))
            print(f"  {var:6s}: House {house}")
        else:
            print(f"  {var:6s}: No solution found!")
            return False
    
    # Verify the solution
    print("\nVerifying solution...")
    print("-" * 40)
    
    errors = []
    
    # Check that all domains have exactly one value
    for var in ['Red', 'Blue', 'Green', 'Cat', 'Dog', 'Zebra']:
        if len(domains[var]) != 1:
            errors.append(f"Variable {var} has {len(domains[var])} values instead of 1")
    
    # If any domain is invalid, skip detailed checks to avoid StopIteration
    if errors:
        print("\n" + "=" * 40)
        print("VALIDATION FAILED")
        print("=" * 40)
        for error in errors:
            print(f"  ✗ {error}")
        return False
    
    # Clue 1: Cat lives in Red House
    if domains['Cat'] != domains['Red']:
        errors.append("Clue 1 violated: Cat and Red should be in same house")
    else:
        print("  ✓ Clue 1: Cat lives in Red House")
    
    # Clue 2: Red House is middle
    if domains['Red'] != {2}:
        errors.append("Clue 2 violated: Red should be in house 2")
    else:
        print("  ✓ Clue 2: Red House is the middle house")
    
    # Clue 3: Blue is left of Red
    blue_h = next(iter(domains['Blue']))
    red_h = next(iter(domains['Red']))
    if blue_h != red_h - 1:
        errors.append(f"Clue 3 violated: Blue ({blue_h}) should be left of Red ({red_h})")
    else:
        print("  ✓ Clue 3: Blue House is directly left of Red House")
    
    # Clue 4: Dog lives in Blue House
    if domains['Dog'] != domains['Blue']:
        errors.append("Clue 4 violated: Dog and Blue should be in same house")
    else:
        print("  ✓ Clue 4: Dog lives in Blue House")
    
    # Clue 5: Zebra in remaining house
    houses = {1, 2, 3}
    expected_zebra = houses - domains['Blue'] - domains['Red']
    if domains['Zebra'] != expected_zebra:
        errors.append(f"Clue 5 violated: Zebra should be in house {expected_zebra}")
    else:
        print("  ✓ Clue 5: Zebra lives in remaining house")
    
    # All-different for colors
    color_houses = [next(iter(domains[c])) for c in ['Red', 'Blue', 'Green']]
    if len(set(color_houses)) != 3:
        errors.append("Colors are not all in different houses")
    else:
        print("  ✓ All colors in different houses")
    
    # All-different for animals
    animal_houses = [next(iter(domains[a])) for a in ['Cat', 'Dog', 'Zebra']]
    if len(set(animal_houses)) != 3:
        errors.append("Animals are not all in different houses")
    else:
        print("  ✓ All animals in different houses")
    
    # Report results
    print("\n" + "=" * 40)
    if errors:
        print("VALIDATION FAILED")
        print("=" * 40)
        for error in errors:
            print(f"  ✗ {error}")
        return False
    else:
        print("VALIDATION PASSED")
        print("=" * 40)
        zebra_house = next(iter(domains['Zebra']))
        print(f"\nAnswer: The Zebra lives in house {zebra_house}.")
        return True

if __name__ == '__main__':
    success = extract_and_run_solver()
    sys.exit(0 if success else 1)

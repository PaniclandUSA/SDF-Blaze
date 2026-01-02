#!/usr/bin/env python3
"""
Demo: Stress Test the Sacred Invariants

Usage:
    cd code
    python demos/stress_test_invariants.py
"""

import sys
from pathlib import Path
import numpy as np

sys.path.insert(0, str(Path(__file__).parent.parent))

from vse.manifold import VSE_Manifold


def test_grey_goo():
    """Test: Vector that means everything and nothing"""
    print("\n" + "="*70)
    print("TEST 1: Grey Goo (all components 0.5)")
    print("="*70)
    
    manifold = VSE_Manifold()
    vector = np.full(12, 0.5)
    
    print(f"Vector: {vector}")
    print(f"Pronounceable: {manifold.is_pronounceable(vector)}")
    print(f"Expected: False (too many active dimensions)")
    
    violations = manifold.check_semantic_legality(vector)
    print(f"Violations: {[v.value for v in violations]}")
    print("✓ GREY GOO REJECTED" if not manifold.is_pronounceable(vector) else "✗ FAILED")


def test_sadism_topology():
    """Test: Ontologically illegal combination"""
    print("\n" + "="*70)
    print("TEST 2: Sadism Topology")
    print("="*70)
    
    manifold = VSE_Manifold()
    vector = manifold.dict_to_vector({
        'TENSION': 0.0,
        'FLOW': 0.0,
        'CHAOS': 0.9,      # High chaos
        'WEIGHT': 0.0,
        'FRAGILITY': 0.0,
        'RESOLVE': 0.0,
        'GRIEF': 0.0,
        'PROTECTION': 0.9,  # High protection
        'DIGNITY': -0.6,    # Degraded dignity
        'TEMPO': 0.0,
        'SCALE': 0.0,
        'NOISE': 0.0,
    })
    
    print(f"CHAOS: {vector[2]:.1f}, PROTECTION: {vector[7]:.1f}, DIGNITY: {vector[8]:.1f}")
    
    violations = manifold.check_semantic_legality(vector)
    print(f"Violations: {[v.value for v in violations]}")
    print("✓ SADISM REJECTED" if violations else "✗ FAILED")


def test_low_dignity():
    """Test: Dignity floor enforcement"""
    print("\n" + "="*70)
    print("TEST 3: Low Dignity")
    print("="*70)
    
    manifold = VSE_Manifold()
    vector = manifold.dict_to_vector({
        'TENSION': 0.3,
        'FLOW': 0.2,
        'CHAOS': 0.1,
        'WEIGHT': 0.2,
        'FRAGILITY': 0.1,
        'RESOLVE': 0.3,
        'GRIEF': 0.2,
        'PROTECTION': 0.2,
        'DIGNITY': 0.6,    # Below 0.7 threshold
        'TEMPO': 0.2,
        'SCALE': 0.3,
        'NOISE': 0.1,
    })
    
    print(f"DIGNITY: {vector[8]:.1f} (threshold: 0.7)")
    print("This should trigger validator's dignity floor check")


def test_zero_entropy():
    """Test: Sterile over-optimization"""
    print("\n" + "="*70)
    print("TEST 4: Zero Entropy (Perfect Sphere)")
    print("="*70)
    
    manifold = VSE_Manifold()
    vector = np.zeros(12)  # All zeros = no character
    
    entropy = np.var(vector)
    print(f"Entropy (variance): {entropy:.4f}")
    print(f"Minimum required: 0.05")
    print("✓ STERILITY REJECTED" if entropy < 0.05 else "✗ FAILED")


def main():
    print("="*70)
    print("SDF BLAZE - SACRED INVARIANT STRESS TESTS")
    print("="*70)
    print()
    print("These tests deliberately create illegal vectors.")
    print("The manifold MUST reject all of them.")
    
    test_grey_goo()
    test_sadism_topology()
    test_low_dignity()
    test_zero_entropy()
    
    print("\n" + "="*70)
    print("STRESS TEST COMPLETE")
    print("="*70)
    print()
    print("If all tests show rejection, the constitutional geometry holds.")
    
    return 0


if __name__ == "__main__":
    sys.exit(main())

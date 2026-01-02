#!/usr/bin/env python3
"""
Demo: Validate the Golden Artifact

Usage:
    cd code
    python demos/validate_golden_artifact.py
"""

import json
import sys
from pathlib import Path

# Ensure code directory is in path
sys.path.insert(0, str(Path(__file__).parent.parent))

from vse.manifold import VSE_Manifold
from pivotgram.validator import PivotgramValidator


def main():
    print("="*70)
    print("SDF BLAZE - GOLDEN ARTIFACT VALIDATION")
    print("="*70)
    print()
    
    # Load golden artifact (relative to code directory)
    artifact_path = Path(__file__).parent.parent / "golden_artifacts" / "weeping_sentinel.json"
    
    if not artifact_path.exists():
        print(f"ERROR: Golden artifact not found at {artifact_path}")
        return 1
    
    with open(artifact_path, 'r') as f:
        artifact = json.load(f)
    
    print(f"Artifact ID: {artifact['artifact_id']}")
    print(f"Title: {artifact['intent']['title']}")
    print(f"Description: {artifact['intent']['description']}")
    print()
    
    # Create manifold and validator
    print("Initializing VSE Manifold...")
    manifold = VSE_Manifold()
    validator = PivotgramValidator(manifold)
    
    # Verify manifold hash
    manifold_hash = manifold.compute_manifold_hash()
    print(f"Manifold Hash: {manifold_hash}")
    print(f"Expected Hash: {artifact['manifold']['manifold_hash']}")
    
    if manifold_hash != artifact['manifold']['manifold_hash']:
        print("⚠️  WARNING: Manifold hash mismatch!")
    else:
        print("✓ Manifold hash verified")
    print()
    
    # Compute artifact hash
    artifact_hash = validator._compute_artifact_hash(artifact)
    print(f"Artifact Hash: {artifact_hash[:32]}...")
    print()
    
    # Run full validation
    print("Running constitutional validation...")
    print()
    is_valid, results = validator.validate_artifact(artifact)
    
    # Display results
    validator.print_validation_report(results)
    
    # Summary
    print()
    print("="*70)
    if is_valid:
        print("✓ ARTIFACT IS CONSTITUTIONALLY VALID")
        print()
        print("This Pivotgram:")
        print("  - Respects all sacred invariants")
        print("  - Maintains dignity threshold")
        print("  - Preserves minimum entropy")
        print("  - Contains no forbidden topologies")
        print("  - May be rendered/materialized")
    else:
        print("✗ ARTIFACT VIOLATES CONSTITUTIONAL REQUIREMENTS")
        print()
        print("This Pivotgram MUST be rejected.")
        print("See violations above for details.")
    print("="*70)
    
    return 0 if is_valid else 1


if __name__ == "__main__":
    sys.exit(main())

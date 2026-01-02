"""
Demo: Validate the Golden Artifact

Demonstrates:
- Loading a Pivotgram artifact
- Running full validation
- Displaying results
"""

import json
import sys
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from vse.manifold import VSE_Manifold
from pivotgram.validator import PivotgramValidator


def main():
    # Load golden artifact
    artifact_path = Path(__file__).parent.parent / "golden_artifacts" / "weeping_sentinel.json"
    
    with open(artifact_path, 'r') as f:
        artifact = json.load(f)
    
    print("Loaded artifact:", artifact['artifact_id'])
    print("Title:", artifact['intent']['title'])
    print()
    
    # Create manifold and validator
    manifold = VSE_Manifold()
    validator = PivotgramValidator(manifold)
    
    # Compute and update hashes
    manifold_hash = manifold.compute_manifold_hash()
    artifact['manifold']['manifold_hash'] = manifold_hash
    
    artifact_hash = validator._compute_artifact_hash(artifact)
    artifact['commit']['artifact_hash'] = artifact_hash
    artifact['commit']['stack_hash'] = artifact_hash  # Simplified
    
    print(f"Manifold Hash: {manifold_hash[:32]}...")
    print(f"Artifact Hash: {artifact_hash[:32]}...")
    print()
    
    # Validate
    is_valid, results = validator.validate_artifact(artifact)
    
    # Display results
    validator.print_validation_report(results)
    
    # Summary
    print()
    if is_valid:
        print("✓ ARTIFACT IS VALID")
        print("This Pivotgram is legally constituted and may be rendered.")
    else:
        print("✗ ARTIFACT IS INVALID")
        print("This Pivotgram violates sacred invariants and must be rejected.")
    
    return 0 if is_valid else 1


if __name__ == "__main__":
    sys.exit(main())

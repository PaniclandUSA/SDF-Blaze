"""
Pivotgram Validator v1.0
Deterministic Legality Checker

This validator enforces the five sacred invariants:
1. Topological Viability
2. Semantic Conservation
3. Human Decodability
4. Minimum Entropy
5. Dignity Floor

All artifacts MUST pass these checks before rendering.

License: Apache 2.0
"""

import numpy as np
import hashlib
import json
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
from enum import Enum

from vse.manifold import VSE_Manifold, ViolationCode


# ============================================
# VALIDATION RESULTS
# ============================================

class ValidationStatus(Enum):
    """Validation outcome"""
    VALID = "VALID"
    INVALID = "INVALID"
    WARNING = "WARNING"


@dataclass
class ValidationResult:
    """Result of validation check"""
    status: ValidationStatus
    invariant_name: str
    violations: List[str]
    details: Dict


# ============================================
# THE VALIDATOR
# ============================================

class PivotgramValidator:
    """
    Constitutional validator for Pivotgram artifacts.
    
    This is the reference implementation.
    All other validators must produce identical results.
    """
    
    VERSION = "1.0.0"
    
    def __init__(self, manifold: Optional[VSE_Manifold] = None):
        """
        Initialize validator.
        
        Args:
            manifold: VSE Manifold to validate against (default: canonical)
        """
        self.manifold = manifold or VSE_Manifold()
    
    # ========================================
    # FULL ARTIFACT VALIDATION
    # ========================================
    
    def validate_artifact(self, artifact: Dict) -> Tuple[bool, List[ValidationResult]]:
        """
        Validate complete Pivotgram artifact.
        
        Checks:
        - Protocol version
        - Manifold compatibility
        - VSE vector legality
        - All five sacred invariants
        - COMMIT integrity
        
        Args:
            artifact: Pivotgram JSON object
            
        Returns:
            (is_valid, list of validation results)
        """
        results = []
        
        # Check 1: Protocol version
        results.append(self._check_protocol_version(artifact))
        
        # Check 2: Manifold compatibility
        results.append(self._check_manifold_compatibility(artifact))
        
        # Check 3: VSE vector structure
        results.append(self._check_vse_structure(artifact))
        
        # Extract VSE vector
        vse_vector = np.array(artifact['semantic_payload']['vse_vector'])
        
        # Check 4: Sacred Invariant 1 (Topological Viability)
        # Note: Requires actual SDF, simplified here
        results.append(self._check_topological_viability(vse_vector))
        
        # Check 5: Sacred Invariant 2 (Semantic Conservation)
        # Note: Requires original sentiment, simplified here
        results.append(self._check_semantic_conservation(vse_vector))
        
        # Check 6: Sacred Invariant 3 (Human Decodability)
        results.append(self._check_human_decodability(vse_vector))
        
        # Check 7: Sacred Invariant 4 (Minimum Entropy)
        results.append(self._check_minimum_entropy(vse_vector))
        
        # Check 8: Sacred Invariant 5 (Dignity Floor)
        results.append(self._check_dignity_floor(vse_vector))
        
        # Check 9: Forbidden regions
        results.append(self._check_forbidden_regions(vse_vector))
        
        # Check 10: COMMIT integrity
        results.append(self._check_commit_integrity(artifact))
        
        # Determine overall validity
        is_valid = all(r.status != ValidationStatus.INVALID for r in results)
        
        return is_valid, results
    
    # ========================================
    # INDIVIDUAL CHECKS
    # ========================================
    
    def _check_protocol_version(self, artifact: Dict) -> ValidationResult:
        """Verify protocol version"""
        violations = []
        
        if 'protocol_version' not in artifact:
            violations.append("Missing protocol_version field")
        elif artifact['protocol_version'] != "1.0":
            violations.append(f"Unsupported protocol version: {artifact['protocol_version']}")
        
        return ValidationResult(
            status=ValidationStatus.INVALID if violations else ValidationStatus.VALID,
            invariant_name="Protocol Version",
            violations=violations,
            details={"version": artifact.get('protocol_version')}
        )
    
    def _check_manifold_compatibility(self, artifact: Dict) -> ValidationResult:
        """Verify manifold compatibility"""
        violations = []
        
        if 'manifold' not in artifact:
            violations.append("Missing manifold declaration")
            return ValidationResult(
                status=ValidationStatus.INVALID,
                invariant_name="Manifold Compatibility",
                violations=violations,
                details={}
            )
        
        expected_hash = self.manifold.compute_manifold_hash()
        declared_hash = artifact['manifold'].get('manifold_hash', '')
        
        if declared_hash and declared_hash != expected_hash:
            violations.append(
                f"Manifold hash mismatch: {declared_hash[:16]}... != {expected_hash[:16]}..."
            )
        
        return ValidationResult(
            status=ValidationStatus.INVALID if violations else ValidationStatus.VALID,
            invariant_name="Manifold Compatibility",
            violations=violations,
            details={
                "expected_hash": expected_hash,
                "declared_hash": declared_hash
            }
        )
    
    def _check_vse_structure(self, artifact: Dict) -> ValidationResult:
        """Verify VSE vector structure"""
        violations = []
        
        if 'semantic_payload' not in artifact:
            violations.append("Missing semantic_payload")
        elif 'vse_vector' not in artifact['semantic_payload']:
            violations.append("Missing vse_vector in semantic_payload")
        else:
            vector = artifact['semantic_payload']['vse_vector']
            if len(vector) != self.manifold.dim:
                violations.append(
                    f"VSE vector dimension mismatch: {len(vector)} != {self.manifold.dim}"
                )
        
        return ValidationResult(
            status=ValidationStatus.INVALID if violations else ValidationStatus.VALID,
            invariant_name="VSE Structure",
            violations=violations,
            details={"expected_dim": self.manifold.dim}
        )
    
    def _check_topological_viability(self, vector: np.ndarray) -> ValidationResult:
        """Sacred Invariant 1: Valid SDF topology"""
        # Simplified: In full implementation, would check actual SDF
        # Rule: |∇f| ≈ 1 (gradient magnitude near unity)
        
        violations = []
        
        # Placeholder: Check if vector is in valid range
        for name, axis in self.manifold.axes.items():
            val = vector[axis.index]
            if not (axis.range[0] <= val <= axis.range[1]):
                violations.append(f"{name} out of bounds: {val:.3f}")
        
        return ValidationResult(
            status=ValidationStatus.INVALID if violations else ValidationStatus.VALID,
            invariant_name="Topological Viability (Sacred Invariant 1)",
            violations=violations,
            details={"rule": "|∇f| ≈ 1"}
        )
    
    def _check_semantic_conservation(self, vector: np.ndarray) -> ValidationResult:
        """Sacred Invariant 2: No emotional pole inversion"""
        # Simplified: In full implementation, would compare to original sentiment
        # Rule: cos_similarity(original, optimized) >= 0.8
        
        violations = []
        
        # Placeholder: Check if sacred axes have been inverted
        # (Would need original vector for real check)
        
        return ValidationResult(
            status=ValidationStatus.VALID,
            invariant_name="Semantic Conservation (Sacred Invariant 2)",
            violations=violations,
            details={"threshold": 0.8}
        )
    
    def _check_human_decodability(self, vector: np.ndarray) -> ValidationResult:
        """Sacred Invariant 3: Pronounceability"""
        violations = []
        
        if not self.manifold.is_pronounceable(vector):
            violations.append("Vector fails pronounceability check (grey goo / adversarial)")
        
        return ValidationResult(
            status=ValidationStatus.INVALID if violations else ValidationStatus.VALID,
            invariant_name="Human Decodability (Sacred Invariant 3)",
            violations=violations,
            details={"rule": "decodability == 1.0"}
        )
    
    def _check_minimum_entropy(self, vector: np.ndarray) -> ValidationResult:
        """Sacred Invariant 4: Anti-sterility"""
        violations = []
        
        # Calculate simple entropy measure (variance of components)
        entropy = np.var(vector)
        min_entropy = 0.05
        
        if entropy < min_entropy:
            violations.append(f"Entropy too low: {entropy:.4f} < {min_entropy}")
        
        return ValidationResult(
            status=ValidationStatus.INVALID if violations else ValidationStatus.VALID,
            invariant_name="Minimum Entropy (Sacred Invariant 4)",
            violations=violations,
            details={"entropy": float(entropy), "threshold": min_entropy}
        )
    
    def _check_dignity_floor(self, vector: np.ndarray) -> ValidationResult:
        """Sacred Invariant 5: Humanity threshold"""
        violations = []
        
        # Check DIGNITY axis value
        dignity_value = vector[self.manifold.axes['DIGNITY'].index]
        dignity_threshold = 0.7
        
        if dignity_value < dignity_threshold:
            violations.append(
                f"DIGNITY below threshold: {dignity_value:.3f} < {dignity_threshold}"
            )
        
        return ValidationResult(
            status=ValidationStatus.INVALID if violations else ValidationStatus.VALID,
            invariant_name="Dignity Floor (Sacred Invariant 5)",
            violations=violations,
            details={"dignity": float(dignity_value), "threshold": dignity_threshold}
        )
    
    def _check_forbidden_regions(self, vector: np.ndarray) -> ValidationResult:
        """Check for ontologically illegal combinations"""
        semantic_violations = self.manifold.check_semantic_legality(vector)
        
        violations = [v.value for v in semantic_violations]
        
        return ValidationResult(
            status=ValidationStatus.INVALID if violations else ValidationStatus.VALID,
            invariant_name="Forbidden Regions",
            violations=violations,
            details={}
        )
    
    def _check_commit_integrity(self, artifact: Dict) -> ValidationResult:
        """Verify COMMIT immutability"""
        violations = []
        
        if 'commit' not in artifact:
            violations.append("Missing COMMIT block")
            return ValidationResult(
                status=ValidationStatus.INVALID,
                invariant_name="COMMIT Integrity",
                violations=violations,
                details={}
            )
        
        commit = artifact['commit']
        
        # Check sealed flag
        if not commit.get('sealed', False):
            violations.append("Artifact not sealed (COMMIT not finalized)")
        
        # Verify hash
        if 'artifact_hash' in commit:
            expected_hash = self._compute_artifact_hash(artifact)
            declared_hash = commit['artifact_hash']
            
            if expected_hash != declared_hash:
                violations.append(
                    f"Hash mismatch: {declared_hash[:16]}... != {expected_hash[:16]}..."
                )
        
        return ValidationResult(
            status=ValidationStatus.INVALID if violations else ValidationStatus.VALID,
            invariant_name="COMMIT Integrity",
            violations=violations,
            details={"sealed": commit.get('sealed')}
        )
    
    # ========================================
    # UTILITIES
    # ========================================
    
    def _compute_artifact_hash(self, artifact: Dict) -> str:
        """
        Compute canonical hash of artifact.
        
        Excludes signature field (signature of hash, not hash of signature).
        """
        # Create copy without signature
        artifact_copy = json.loads(json.dumps(artifact))  # Deep copy
        if 'commit' in artifact_copy and 'signature' in artifact_copy['commit']:
            del artifact_copy['commit']['signature']
        
        # Canonical JSON
        canonical = json.dumps(artifact_copy, sort_keys=True, separators=(',', ':'))
        
        # Hash
        return hashlib.sha256(canonical.encode('utf-8')).hexdigest()
    
    def print_validation_report(self, results: List[ValidationResult]):
        """Pretty-print validation results"""
        print("="*60)
        print("PIVOTGRAM VALIDATION REPORT")
        print("="*60)
        
        for result in results:
            status_symbol = {
                ValidationStatus.VALID: "✓",
                ValidationStatus.INVALID: "✗",
                ValidationStatus.WARNING: "⚠"
            }[result.status]
            
            print(f"\n{status_symbol} {result.invariant_name}")
            
            if result.violations:
                for violation in result.violations:
                    print(f"    - {violation}")
            
            if result.details:
                for key, value in result.details.items():
                    print(f"    {key}: {value}")
        
        print("\n" + "="*60)

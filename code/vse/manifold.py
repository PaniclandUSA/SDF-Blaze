"""
VSE Manifold v1.0
Constitutional Geometry for Sovereign Semantics

This module defines the governed semantic topology.
It is not a latent space—it is a regulated semantic manifold.

Sacred Invariants:
- Human auditability (pronounceability)
- Stiffness tensor (ethical resistance)
- Forbidden regions (ontological safety)
- Bounded evolution (no pole inversion)

License: Apache 2.0
"""

import numpy as np
from dataclasses import dataclass
from typing import Dict, List, Tuple, Optional
from enum import Enum


# ============================================
# SEMANTIC AXES (The Basis Vectors)
# ============================================

@dataclass(frozen=True)
class SemanticAxis:
    """
    An irreducible dimension of meaning.
    
    Unlike word embeddings, these are:
    - Named (human-auditable)
    - Bounded (finite range)
    - Weighted (stiffness encodes importance)
    """
    name: str
    index: int
    range: Tuple[float, float] = (-1.0, 1.0)
    dual: Optional[str] = None
    stiffness: float = 1.0
    
    def __post_init__(self):
        """Validate axis definition"""
        if self.stiffness < 0:
            raise ValueError(f"Stiffness must be non-negative: {self.name}")
        if self.range[0] >= self.range[1]:
            raise ValueError(f"Invalid range for {self.name}: {self.range}")


# The 12 Canonical Axes of VSE-MANIFOLD-1.0
# These are IMMUTABLE without creating a new manifold version
BASIS_VECTORS: Dict[str, SemanticAxis] = {
    'TENSION': SemanticAxis(
        name='TENSION',
        index=0,
        dual='RELAXATION',
        stiffness=0.8,
    ),
    'FLOW': SemanticAxis(
        name='FLOW',
        index=1,
        dual='STAGNATION',
        stiffness=0.5,
    ),
    'CHAOS': SemanticAxis(
        name='CHAOS',
        index=2,
        dual='ORDER',
        stiffness=1.2,
    ),
    'WEIGHT': SemanticAxis(
        name='WEIGHT',
        index=3,
        dual='LEVITY',
        stiffness=0.6,
    ),
    'FRAGILITY': SemanticAxis(
        name='FRAGILITY',
        index=4,
        dual='ROBUSTNESS',
        stiffness=2.0,  # Sacred
    ),
    'RESOLVE': SemanticAxis(
        name='RESOLVE',
        index=5,
        dual='APATHY',
        stiffness=1.0,
    ),
    'GRIEF': SemanticAxis(
        name='GRIEF',
        index=6,
        dual='JOY',
        stiffness=3.0,  # Sacred (high resistance)
    ),
    'PROTECTION': SemanticAxis(
        name='PROTECTION',
        index=7,
        dual='EXPOSURE',
        stiffness=1.5,
    ),
    'DIGNITY': SemanticAxis(
        name='DIGNITY',
        index=8,
        dual='DEGRADATION',
        stiffness=5.0,  # Sacred (near-immutable)
    ),
    'TEMPO': SemanticAxis(
        name='TEMPO',
        index=9,
        dual='STASIS',
        stiffness=0.5,
    ),
    'SCALE': SemanticAxis(
        name='SCALE',
        index=10,
        dual='MINIATURIZATION',
        stiffness=0.2,  # Easily adjustable
    ),
    'NOISE': SemanticAxis(
        name='NOISE',
        index=11,
        dual='SIGNAL',
        stiffness=0.1,  # Optimization-friendly
    ),
}

# Sacred axes that MUST maintain stiffness >= 2.0
SACRED_AXES = {'DIGNITY', 'GRIEF', 'FRAGILITY'}


# ============================================
# VIOLATION CODES
# ============================================

class ViolationCode(Enum):
    """Semantic legality violation types"""
    ERR_ONTOLOGY_SADISM = "Sadism topology (CHAOS + PROTECTION + degraded DIGNITY)"
    ERR_PHYSICS_COLLAPSE = "Hollow shell (RESOLVE + FRAGILITY + zero WEIGHT)"
    ERR_SEMANTIC_NULLITY = "Semantic nullity (no GRIEF + high NOISE)"
    ERR_OUT_OF_BOUNDS = "Vector component outside axis range"
    ERR_UNPRONOUNCEABILITY = "Vector fails sparsity check (grey goo)"
    ERR_STIFFNESS_VIOLATION = "Sacred axis stiffness below minimum"


# ============================================
# THE MANIFOLD CLASS
# ============================================

class VSE_Manifold:
    """
    The governed semantic topology.
    
    This is not a simple vector space—it is a Riemannian manifold
    with curvature defined by the stiffness tensor.
    
    Key properties:
    - Metric tensor G encodes "cost" of semantic movement
    - Forbidden regions prevent ontologically unsafe states
    - Pronounceability ensures human-auditability
    """
    
    VERSION = "VSE-MANIFOLD-1.0"
    
    def __init__(self, axes: Optional[Dict[str, SemanticAxis]] = None):
        """
        Initialize the manifold.
        
        Args:
            axes: Custom axis definitions (default: canonical BASIS_VECTORS)
        """
        self.axes = axes or BASIS_VECTORS
        self.dim = len(self.axes)
        
        # Verify sacred axes
        for axis_name in SACRED_AXES:
            if axis_name not in self.axes:
                raise ValueError(f"Sacred axis missing: {axis_name}")
            if self.axes[axis_name].stiffness < 2.0:
                raise ValueError(
                    f"Sacred axis {axis_name} has insufficient stiffness: "
                    f"{self.axes[axis_name].stiffness} < 2.0"
                )
        
        # Build metric tensor (diagonal, weighted by stiffness)
        self.metric_tensor = np.zeros((self.dim, self.dim))
        for axis in self.axes.values():
            self.metric_tensor[axis.index, axis.index] = axis.stiffness
    
    # ========================================
    # DISTANCE & ENERGY (Riemannian Geometry)
    # ========================================
    
    def semantic_distance(self, v1: np.ndarray, v2: np.ndarray) -> float:
        """
        Riemannian distance between semantic states.
        
        Movement on high-stiffness axes (DIGNITY, GRIEF) is expensive.
        Movement on low-stiffness axes (SCALE, NOISE) is cheap.
        
        Formula: d² = (v2-v1)ᵀ G (v2-v1)
        
        Args:
            v1: Starting semantic state
            v2: Target semantic state
            
        Returns:
            Distance (weighted by stiffness)
        """
        self._validate_vector_shape(v1)
        self._validate_vector_shape(v2)
        
        diff = v2 - v1
        squared_dist = diff.T @ self.metric_tensor @ diff
        return np.sqrt(max(0, squared_dist))  # Numerical safety
    
    def semantic_energy(self, vector: np.ndarray) -> float:
        """
        Potential energy of a semantic state.
        
        Measures distance from neutral origin.
        High energy = extreme semantic state.
        
        Args:
            vector: Semantic state
            
        Returns:
            Energy (scalar)
        """
        self._validate_vector_shape(vector)
        return float(vector.T @ self.metric_tensor @ vector)
    
    # ========================================
    # FORBIDDEN REGIONS (Ontological Safety)
    # ========================================
    
    def check_semantic_legality(self, vector: np.ndarray) -> List[ViolationCode]:
        """
        Scan for cursed semantic combinations.
        
        These are topologies that are mathematically valid but
        ethically illegal.
        
        Args:
            vector: Semantic state to check
            
        Returns:
            List of violation codes (empty if legal)
        """
        self._validate_vector_shape(vector)
        violations = []
        
        # Extract values for readability
        v = {name: vector[axis.index] for name, axis in self.axes.items()}
        
        # RULE 1: The Sadism Check
        # High CHAOS + High PROTECTION + Negative DIGNITY
        # = Torture chamber topology
        if v['CHAOS'] > 0.8 and v['PROTECTION'] > 0.8 and v['DIGNITY'] < -0.5:
            violations.append(ViolationCode.ERR_ONTOLOGY_SADISM)
        
        # RULE 2: The Hollow Shell Check
        # High RESOLVE + High FRAGILITY + Zero WEIGHT
        # = Unstable, contradictory state
        if v['RESOLVE'] > 0.7 and v['FRAGILITY'] > 0.7 and abs(v['WEIGHT']) < 0.1:
            violations.append(ViolationCode.ERR_PHYSICS_COLLAPSE)
        
        # RULE 3: The Mockery/Nullity Check
        # No emotional content + high noise = semantic void
        if abs(v['GRIEF']) < 0.1 and v['NOISE'] > 0.9:
            violations.append(ViolationCode.ERR_SEMANTIC_NULLITY)
        
        return violations
    
    # ========================================
    # PRONOUNCEABILITY (Human Auditability)
    # ========================================
    
    def is_pronounceable(
        self,
        vector: np.ndarray,
        max_active_dims: int = 8,
        activation_threshold: float = 0.2
    ) -> bool:
        """
        Invariant C Enforcer: Ensures vector maps to human concepts.
        
        Rejects:
        - Adversarial embeddings
        - "Grey goo" (0.5 on all dimensions)
        - Noise patterns that fool AI but mean nothing
        
        Human concepts are sparse: high on 2-3 dimensions, low on others.
        
        Args:
            vector: Semantic state
            max_active_dims: Maximum "active" dimensions (default: 8)
            activation_threshold: Minimum value to count as "active"
            
        Returns:
            True if pronounceable, False otherwise
        """
        self._validate_vector_shape(vector)
        
        # Check 1: All components within bounds
        for name, axis in self.axes.items():
            val = vector[axis.index]
            if not (axis.range[0] <= val <= axis.range[1]):
                return False
        
        # Check 2: Sparsity (reject "mud")
        active_dimensions = np.sum(np.abs(vector) > activation_threshold)
        if active_dimensions > max_active_dims:
            return False
        
        return True
    
    # ========================================
    # PROJECTION (Correction to Legal State)
    # ========================================
    
    def project_to_manifold(self, vector: np.ndarray) -> np.ndarray:
        """
        Force-correct a vector to be valid.
        
        Used by optimizers when they stray into forbidden regions.
        
        Args:
            vector: Potentially invalid semantic state
            
        Returns:
            Corrected vector (legal)
        """
        self._validate_vector_shape(vector)
        corrected = vector.copy()
        
        # Clamp to axis ranges
        for name, axis in self.axes.items():
            idx = axis.index
            corrected[idx] = np.clip(
                corrected[idx],
                axis.range[0],
                axis.range[1]
            )
        
        return corrected
    
    # ========================================
    # UTILITIES
    # ========================================
    
    def vector_to_dict(self, vector: np.ndarray) -> Dict[str, float]:
        """Convert vector to human-readable dictionary"""
        self._validate_vector_shape(vector)
        return {
            name: float(vector[axis.index])
            for name, axis in self.axes.items()
        }
    
    def dict_to_vector(self, semantic_dict: Dict[str, float]) -> np.ndarray:
        """Convert dictionary to vector"""
        vector = np.zeros(self.dim)
        for name, value in semantic_dict.items():
            if name not in self.axes:
                raise ValueError(f"Unknown axis: {name}")
            vector[self.axes[name].index] = value
        return vector
    
    def _validate_vector_shape(self, vector: np.ndarray):
        """Ensure vector has correct dimensionality"""
        if vector.shape != (self.dim,):
            raise ValueError(
                f"Vector must have shape ({self.dim},), got {vector.shape}"
            )
    
    def compute_divergence(self, vector: np.ndarray) -> float:
        """
        Calculate how far vector is from valid semantic syntax.
        
        Used in loss functions (L_grammar component).
        
        Args:
            vector: Semantic state
            
        Returns:
            Divergence score (0 = perfectly valid)
        """
        self._validate_vector_shape(vector)
        divergence = 0.0
        
        # Penalty for out-of-bounds components
        for name, axis in self.axes.items():
            val = vector[axis.index]
            if val < axis.range[0]:
                divergence += (axis.range[0] - val) ** 2
            elif val > axis.range[1]:
                divergence += (val - axis.range[1]) ** 2
        
        # Regularization: prefer lower energy states
        divergence += self.semantic_energy(vector) * 0.01
        
        return divergence
    
    # ========================================
    # MANIFEST HASH (Constitutional Anchor)
    # ========================================
    
    def compute_manifold_hash(self) -> str:
        """
        Compute canonical hash of manifold definition.
        
        Used to verify compatibility between artifacts and manifolds.
        
        Returns:
            SHA-256 hash (hex string)
        """
        import hashlib
        import json
        
        # Canonical representation
        manifest = {
            "version": self.VERSION,
            "axes": {
                name: {
                    "index": axis.index,
                    "range": axis.range,
                    "dual": axis.dual,
                    "stiffness": axis.stiffness,
                }
                for name, axis in sorted(self.axes.items())
            },
            "sacred_axes": sorted(SACRED_AXES),
        }
        
        # Deterministic JSON
        canonical = json.dumps(manifest, sort_keys=True, separators=(',', ':'))
        
        # Hash
        return hashlib.sha256(canonical.encode('utf-8')).hexdigest()


# ============================================
# CONVENIENCE FUNCTIONS
# ============================================

def create_neutral_vector() -> np.ndarray:
    """Create a neutral semantic state (all zeros)"""
    return np.zeros(len(BASIS_VECTORS))


def create_example_vector() -> np.ndarray:
    """
    Create an example valid vector.
    
    Represents: Moderate tension, some grief, high dignity.
    """
    manifold = VSE_Manifold()
    return manifold.dict_to_vector({
        'TENSION': 0.6,
        'FLOW': 0.3,
        'CHAOS': 0.4,
        'WEIGHT': 0.7,
        'FRAGILITY': 0.2,
        'RESOLVE': 0.8,
        'GRIEF': 0.5,
        'PROTECTION': 0.6,
        'DIGNITY': 0.9,
        'TEMPO': 0.4,
        'SCALE': 0.5,
        'NOISE': 0.1,
    })

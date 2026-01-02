"""
VSE (Vector Space Esperanto)
Constitutional semantic manifold for SDF Blaze

This package defines the governed topology of meaning.
"""

from .manifold import (
    VSE_Manifold,
    SemanticAxis,
    ViolationCode,
    BASIS_VECTORS,
    SACRED_AXES,
    create_neutral_vector,
    create_example_vector,
)

__version__ = "1.0.0"
__all__ = [
    "VSE_Manifold",
    "SemanticAxis",
    "ViolationCode",
    "BASIS_VECTORS",
    "SACRED_AXES",
    "create_neutral_vector",
    "create_example_vector",
]

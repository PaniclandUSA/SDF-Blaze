# SDF Blaze - Code Implementation

This directory contains the reference implementation of the Pivotgram protocol.

## Structure
```
code/
├── vse/                    # VSE Manifold (constitutional geometry)
├── pivotgram/              # Pivotgram validator
├── golden_artifacts/       # Reference Pivotgrams
├── demos/                  # Demonstration scripts
└── tests/                  # Unit tests
```

## Installation
```bash
cd code
pip install -r requirements.txt
```

## Quick Start

### Validate the Golden Artifact
```bash
cd code
python demos/validate_golden_artifact.py
```

Expected output:
```
✓ ARTIFACT IS CONSTITUTIONALLY VALID
```

### Stress Test Sacred Invariants
```bash
python demos/stress_test_invariants.py
```

This will verify that the manifold rejects:
- Grey goo vectors
- Sadism topology
- Low dignity states
- Zero entropy (sterile optimization)

## Running Tests
```bash
python -m pytest tests/
```

## Manifold Hash

The canonical VSE-MANIFOLD-1.0 hash is:
```
1beec815523cc6b68ecadc859838a82656a3686314c9a448ee975a9f15a49b66
```

Any artifact claiming compatibility must match this hash.

## Documentation

See `/docs/` in the repository root for:
- MANIFEST.md - Founding vision
- GOVERNANCE.md - Constitutional rules
- PROTOCOL.md - Technical specification
```

---

## READY TO PUSH

Your file structure is now:
```
SDF-Blaze/
├── README.md
├── MANIFEST.md
├── GOVERNANCE.md
├── LICENSE
├── docs/
│   ├── PROTOCOL.md
│   └── architecture/
└── code/
    ├── README.md
    ├── requirements.txt
    ├── __init__.py
    ├── vse/
    │   ├── __init__.py
    │   └── manifold.py
    ├── pivotgram/
    │   ├── __init__.py
    │   └── validator.py
    ├── golden_artifacts/
    │   └── weeping_sentinel.json
    ├── demos/
    │   ├── validate_golden_artifact.py
    │   └── stress_test_invariants.py
    └── tests/
        └── test_manifold.py

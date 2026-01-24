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
# SDF-Blaze: Constitutional Game Design

**The Corpuscle Crew™** - A twin-stick shooter/tower defense hybrid 
that proves geometry can be truth even under extreme constraint.

## What is SDF-Blaze?

SDF-Blaze is a constitutional approach to game development where:
- **Geometry is semantic truth**, not decoration
- **Performance is guaranteed**, not hoped for
- **Mutation is mathematical**, not sprite-based
- **Design is disciplined**, not feature-creep

## The Fossil Record

[`code/Pico-8/Corpusle_v2.p8`](code/Pico-8/Corpusle_v2.p8) is the 
canonical reference implementation demonstrating all principles 
at 128×128 pixels in under 850 tokens.

### Play it Now
- [Web Player](https://www.pico-8-edu.com/?c=AHB4YV9....) (TODO)
- [Download .p8](code/Pico-8/Corpusle_v2.p8)
- [Lexaloffle BBS](https://www.lexaloffle.com/bbs/?tid=...) (TODO)

## Core Principles

1. **Article I: Core Invariants** - Phase alternation, crew archetypes
2. **Article II: PI Compliance** - Guaranteed frame budgets
3. **Article VII: Pathological Geometry** - Bosses are equations

[Read Full Constitution →](CONSTITUTION.md)

## Educational Context

The Corpuscle Crew is set inside a human body fighting Lyme disease 
spirochetes. The game uses biological accuracy to teach:
- How *Borrelia burgdorferi* spirals through tissue
- Why the immune system needs help with chronic infections
- How nanomedicine might work at cellular scale

## Community

- Report bugs: [Issues](https://github.com/PaniclandUSA/SDF-Blaze/issues)
- Share ports: [Discussions](https://github.com/PaniclandUSA/SDF-Blaze/discussions)
- Read devlog: [Wiki](https://github.com/PaniclandUSA/SDF-Blaze/wiki)

## License

[Choose: MIT for code permissiveness, or CC-BY-SA for documentation]

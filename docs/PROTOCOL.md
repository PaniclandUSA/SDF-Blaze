PROTOCOL.md

Pivotgram Transmission Protocol

Version: 1.0
Status: Active / Constitutional
Effective Date: January 1, 2026
Codename: SDF Blaze / Sovereign Semantics


---

0. Purpose

The Pivotgram Protocol defines how meaning is transmitted, verified, reconstructed, and protected across media without degradation, manipulation, or loss of human dignity.

This protocol governs:

Semantic transmission

Geometric reconstruction

Ethical enforcement

Observer interaction

Immutability guarantees


It is not optional for compliant implementations.


---

1. Prime Directive: Semantic Stewardship

All protocol operations are subordinate to Semantic Stewardship.

This protocol explicitly prioritizes:

1. Human dignity


2. Semantic fidelity


3. Decodability


4. Ethical resistance to optimization



Over:

Performance

Compression

Engagement

Platform convenience


Any implementation that violates this hierarchy is non-compliant.


---

2. Canonical Artifact: The Pivotgram

A Pivotgram Artifact is the atomic unit of transmission.

It is not:

A mesh

A texture

A recording

A replayable performance


It is:

A governed semantic seed

A reconstructible intent

A constitutionally constrained object



---

3. Mandatory Artifact Structure

Every Pivotgram Artifact MUST contain the following sections:

3.1 Header

{
  "protocol_version": "1.0",
  "artifact_id": "pg:<namespace>:<name>:<version>",
  "created_utc": "ISO-8601 timestamp"
}


---

3.2 Manifold Declaration

Every artifact is valid only relative to a declared VSE Manifold.

{
  "manifold": {
    "manifold_version": "VSE-MANIFOLD-1.0",
    "manifold_hash": "sha256:..."
  }
}

Receivers MUST:

Recognize the manifold hash or

Reject the artifact



---

3.3 Semantic Payload (VSE Vector)

{
  "semantic_payload": {
    "vse_vector_format": "float32[N]",
    "vse_vector": [ ... ]
  }
}

Constraints:

Vector MUST be pronounceable

Vector MUST pass all invariant checks

Vector MUST lie within manifold bounds



---

3.4 Instruction Stack (Glyph Program)

The stack defines how meaning is instantiated, not what it means.

{
  "stack": [
    { "glyph": "U+E118", "args": {...} },
    { "glyph": "U+E138", "args": {...} },
    ...
    { "glyph": "U+E159", "args": {} }
  ]
}

Rules:

Stack is executed sequentially

U+E159 (COMMIT) MUST be last

No executable glyphs allowed after COMMIT



---

3.5 Sacred Invariants (Hard Gates)

All artifacts MUST declare and pass the following invariants:

Invariant	Description

Topological Viability	Valid SDF manifold
Semantic Conservation	No emotional pole inversion
Human Decodability	Pronounceable meaning
Minimum Entropy	Anti-sterility
Dignity Floor	Humanity preserved


Failure of any invariant = hard rejection


---

3.6 Ambience Envelope (Optional but Governed)

If present, Ambience MUST be:

{
  "ambience": {
    "enabled": true,
    "opt_in_required": true,
    "reactivity": 0.30,
    "momentum": 0.85,
    "axis_caps": {...},
    "sacred_axes_lock": ["DIGNITY", "GRIEF"],
    "telemetry_transparency": true
  }
}

Hard rules:

Viewer state is read-only

No feedback optimization loops

Maximum 30% semantic influence

All modulation must be visible



---

4. Receiver Obligations (Deterministic)

A compliant receiver MUST perform the following steps in order:

1. Canonicalize artifact (deterministic serialization)


2. Verify manifold compatibility


3. Verify invariant declarations


4. Validate semantic payload


5. Execute stack up to COMMIT


6. Seal artifact (immutability)


7. Instantiate reconstruction


8. Enforce ambience envelope (if present)


9. Expose transparency channel



Skipping any step = non-compliance.


---

5. COMMIT Protocol (U+E159)

The COMMIT glyph enforces semantic sovereignty.

After COMMIT:

Artifact hash is finalized

No mutation is permitted

No remixing under same ID

No re-optimization allowed


Any change requires:

New artifact_id

New hash

Explicit fork lineage


COMMIT is irreversible.


---

6. Mutation Rules

6.1 Pre-COMMIT

Allowed:

Optimization

Projection to manifold

Collaborative interpolation

Remixing


6.2 Post-COMMIT

Allowed:

Runtime ambience modulation (non-persistent)

Rendering in different media


Forbidden:

Changing VSE vector

Changing stack

Changing invariants

Changing manifold reference



---

7. Forbidden Operations (Protocol-Level)

A compliant system MUST NOT:

Encrypt semantic meaning

Hide modulation logic

Optimize viewer emotion

Bypass pronounceability

Lower stiffness of sacred axes

Remove invariant enforcement

Allow COMMIT rollback


Violations constitute a Hostile Fork.


---

8. Transparency Requirement

All implementations MUST expose:

Active semantic axes

Current modulation values

Invariant enforcement events

Clamping or rejection reasons


No black-box behavior is permitted.


---

9. Compatibility & Forking

9.1 Compatible Implementations

Must retain protocol name

Must preserve sacred invariants

May extend renderers or axes


9.2 Hard Forks

If any sacred invariant is removed or weakened:

Protocol name MUST change

Artifact namespace MUST change

Manifold hash MUST change


The name Pivotgram is reserved for compliant systems only.


---

10. Closing Statement

This protocol does not describe a tool.

It describes:

How meaning travels

How dignity is preserved

How systems are prevented from lying

How art can refuse degradation


This is not a best practice.
This is a constitutional requirement.


---

Canonical Phrase (Normative)

> The manifold has curvature.
Some paths are expensive.
Some regions are forbidden.
Some axes cannot yield.

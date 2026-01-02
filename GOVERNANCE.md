# 🏛️ GOVERNANCE.md

**The Constitutional Framework of SDF Blaze**

---

## Preamble

This document defines the **governance structure** of the SDF Blaze system.

Unlike most open-source projects, which govern process and contribution, this document governs **what may and may not be changed** within the system itself.

**This is not a code of conduct.**  
**This is a constitutional limit on maintainer authority.**

Certain aspects of this system are **immutable by design**.  
Others are **evolvable within constraints**.

This document distinguishes between the two.

---

## I. Foundational Principles (Immutable)

These principles **cannot be removed or weakened** without creating a fundamentally different system.

Any fork that violates these principles **may not call itself SDF Blaze or Pivotgram-compliant**.

### **Principle 1: Human Auditability**

**Statement:**  
Every semantic operation must be decodable into human concepts.

**Requirement:**  
- All VSE vectors must pass `is_pronounceable()` validation
- No encrypted or obfuscated semantic encodings
- All transformations must be traceable to named axes

**Enforcement:**  
Validator MUST reject vectors that fail decodability checks.

**Rationale:**  
Without this, the system becomes a black box that may claim to preserve meaning while actually encoding arbitrary data.

---

### **Principle 2: Sacred Invariants**

**Statement:**  
Five invariant checks are mandatory for all legal artifacts.

**The Five Invariants:**

1. **Topological Viability**  
   - Rule: `|∇f(x)| ≈ 1` (valid signed distance field)
   - Tolerance: 0.1
   - Prevents: Non-manifold geometry, impossible surfaces

2. **Semantic Conservation**  
   - Rule: `cos_similarity(original_sentiment, optimized_sentiment) ≥ 0.8`
   - Prevents: Emotional pole inversion (grief → joy optimization)

3. **Human Decodability**  
   - Rule: `decodability == 1.0`
   - Prevents: Adversarial embeddings, semantic noise

4. **Minimum Entropy**  
   - Rule: `surface_entropy ≥ 0.05`
   - Prevents: Sterile over-optimization, loss of character

5. **Dignity Floor**  
   - Rule: `humanity_score ≥ 0.7`
   - Prevents: Degradation of human-centric forms

**Enforcement:**  
All validators, compilers, and renderers MUST implement these checks.  
Artifacts failing ANY invariant MUST be rejected before rendering.

**Rationale:**  
These are not preferences—they are **ontological safety rails**.

---

### **Principle 3: COMMIT Immutability**

**Statement:**  
After the COMMIT glyph (`U+E159`), a Pivotgram artifact becomes **immutable**.

**Requirements:**
- `artifact_hash` is computed from canonical form
- No modification to:
  - `semantic_payload.vse_vector`
  - `stack` (instruction sequence)
  - `loss_policy`
  - `invariants`
  - `manifold_hash`
- Any change creates a **new artifact** with new `artifact_id`

**Enforcement:**  
Validators MUST verify `artifact_hash` matches recomputed hash.  
Any mismatch MUST cause rejection.

**Rationale:**  
COMMIT creates **semantic sovereignty**—the artifact becomes a permanent record.

---

### **Principle 4: Bounded Ambience**

**Statement:**  
Observer influence must be **opt-in, bounded, and transparent**.

**Requirements:**
- `opt_in_required: true` for any biometric coupling
- `reactivity ≤ 0.5` (observer influence ≤ 50%)
- Sacred axes (DIGNITY, GRIEF) have `axis_caps ≤ 0.02`
- `telemetry_transparency: true` (changes must be visible)

**Forbidden:**
- Optimizing viewer state as objective function
- Hidden feedback loops
- Covert emotional manipulation

**Enforcement:**  
Runtime systems MUST expose ambience influence in UI.  
Ambience envelopes exceeding limits MUST be rejected.

**Rationale:**  
The viewer is a participant, not a resource to be optimized.

---

### **Principle 5: Stiffness Tensor Integrity**

**Statement:**  
The VSE Manifold's stiffness values encode **what cannot be compromised**.

**Current Stiffness Values (v1.0):**
```
DIGNITY:    5.0  (near-immutable)
GRIEF:      3.0  (high resistance)
FRAGILITY:  2.0  (protected)
PROTECTION: 1.5
CHAOS:      1.2
RESOLVE:    1.0
TENSION:    0.8
WEIGHT:     0.6
FLOW:       0.5
TEMPO:      0.5
SCALE:      0.2  (easily adjustable)
NOISE:      0.1  (optimization-friendly)
```

**Requirement:**  
Sacred axes (DIGNITY, GRIEF, FRAGILITY) MUST maintain stiffness ≥ 2.0.

**Changes Allowed:**
- New axes may be added
- Stiffness may be **increased** (making axes more sacred)
- Non-sacred axes (stiffness < 1.0) may be adjusted

**Changes Forbidden:**
- Reducing stiffness of sacred axes below 2.0
- Removing named axes that existing artifacts depend on
- Inverting dual relationships (e.g., making CHAOS the dual of FLOW)

**Rationale:**  
Stiffness is not a parameter—it's an **ethical commitment**.

---

## II. Evolvable Components (Governed Change)

These may be modified through the **Amendment Process** (Section V).

### **A. Semantic Axes**

**Current Axes (v1.0):** 12 canonical dimensions  
**Allowed Changes:**
- Add new axes (requires manifold version bump)
- Refine axis definitions
- Adjust non-sacred stiffness values

**Forbidden Changes:**
- Remove axes used by committed artifacts
- Redefine sacred axes (DIGNITY, GRIEF, FRAGILITY)

---

### **B. Forbidden Regions**

**Current Taboos (v1.0):**
- `ERR_ONTOLOGY_SADISM`
- `ERR_PHYSICS_COLLAPSE`
- `ERR_SEMANTIC_NULLITY`

**Allowed Changes:**
- Add new forbidden combinations
- Tighten thresholds

**Forbidden Changes:**
- Remove existing taboo checks
- Weaken thresholds to permit previously illegal states

---

### **C. Pivotgram Opcodes**

**Current Set:** Pivotgram-92 (92 glyphs)  
**Allowed Changes:**
- Add new glyphs (backward compatible)
- Refine opcode semantics
- Optimize implementations

**Forbidden Changes:**
- Change existing opcode semantics (breaks committed artifacts)
- Remove opcodes (breaks backward compatibility)

---

### **D. Validator Implementations**

**Allowed Changes:**
- Performance optimizations
- Additional validation checks
- Better error messages

**Forbidden Changes:**
- Weakening existing checks
- Making validators more permissive

**Requirement:**  
All validators MUST pass the **Golden Artifact Test Suite**.

---

## III. Maintainer Authority

### **What Maintainers May Do**

1. **Accept Contributions**
   - Code improvements
   - Documentation
   - New renderers/exporters
   - Additional validation tools

2. **Version Management**
   - Release new protocol versions
   - Deprecate old formats (with migration tools)
   - Maintain backward compatibility

3. **Tooling Evolution**
   - Improve performance
   - Add platform support
   - Expand material options

4. **Community Governance**
   - Moderate discussions
   - Resolve disputes
   - Manage contributions

---

### **What Maintainers May NOT Do**

1. **Remove Sacred Invariants**
   - Cannot disable dignity checks
   - Cannot make pronounceability optional
   - Cannot weaken semantic conservation

2. **Modify Committed Artifacts**
   - Cannot "fix" historical Pivotgrams
   - Cannot recompute hashes
   - Cannot change manifold versions retroactively

3. **Hide System Behavior**
   - Cannot make VSE→geometry mappings proprietary
   - Cannot encrypt semantic operations
   - Cannot obscure ambience influence

4. **Optimize Away Ethics**
   - Cannot remove stiffness constraints "for performance"
   - Cannot make forbidden regions optional
   - Cannot sacrifice dignity for scale

---

## IV. Fork Policy

### **Permitted Forks**

Anyone may fork this system **with attribution**.

Forks may:
- Experiment with new axes
- Try alternative stiffness values
- Implement different renderers
- Extend the protocol

---

### **Naming Requirements**

Forks **may NOT** use these names if they violate foundational principles:
- "SDF Blaze"
- "Pivotgram"
- "VSE Manifold"
- "Sovereign Semantics"

Forks that remove sacred invariants, weaken dignity protections, or make COMMIT mutable **must use different names**.

---

### **Compliance Statement**

Forks claiming Pivotgram compatibility MUST:
- Implement all five sacred invariants
- Enforce COMMIT immutability
- Maintain human auditability
- Preserve stiffness tensor for sacred axes
- Pass the Golden Artifact Test Suite

Non-compliant forks should clearly state: **"Derived from SDF Blaze, not Pivotgram-compliant."**

---

## V. Amendment Process

### **A. Minor Amendments (Non-Breaking)**

**Examples:**
- Adding new semantic axes
- Tightening validation rules
- Performance improvements
- Documentation updates

**Process:**
1. Proposal filed as GitHub issue
2. Community discussion (14 days minimum)
3. Maintainer review
4. Implementation + version bump
5. Update to Golden Artifacts if needed

**Approval:** Maintainer decision after community input

---

### **B. Major Amendments (Breaking Changes)**

**Examples:**
- New protocol version
- Manifold restructuring
- Opcode semantic changes

**Process:**
1. RFC (Request for Comments) published
2. Community discussion (30 days minimum)
3. Compatibility analysis
4. Migration tool development
5. Phased rollout

**Approval:** Consensus among core maintainers + community support

---

### **C. Constitutional Amendments (Foundational)**

**Examples:**
- Removing a sacred invariant
- Weakening dignity protections
- Making COMMIT mutable

**Process:**
**These changes are NOT PERMITTED.**

If the community believes a foundational principle must change, they must:
1. Fork the repository
2. Create a new system with a new name
3. Publish their rationale

**Rationale:**  
Some principles are **definitional**. Changing them creates a different system.

---

## VI. Enforcement Mechanisms

### **A. Automated Validation**

All implementations MUST include:
- Canonical validator (reference implementation)
- Golden Artifact test suite
- Regression tests for sacred invariants

**Continuous Integration:**  
Pull requests MUST pass all tests before merge.

---

### **B. Community Review**

**Transparency Requirement:**  
All proposed changes to:
- Manifold structure
- Sacred invariants
- Opcode semantics
- Validation rules

MUST be publicly reviewable before implementation.

---

### **C. Version Integrity**

**Semantic Versioning:**
```
MAJOR.MINOR.PATCH

MAJOR: Breaking changes (protocol incompatibility)
MINOR: New features (backward compatible)
PATCH: Bug fixes
```

**Manifold Versions:**
```
VSE-MANIFOLD-X.Y

X: Incompatible changes (new axes, removed axes)
Y: Compatible refinements (stiffness adjustments, new taboos)
```

---

### **D. Artifact Provenance**

All Pivotgram artifacts MUST declare:
```json
{
  "protocol_version": "1.0",
  "manifold_version": "VSE-MANIFOLD-1.0",
  "validator_version": "sdf-blaze-0.1.0"
}
```

This creates **auditable lineage**.

---

## VII. Conflict Resolution

### **Interpretation Disputes**

If there's disagreement about whether a change violates foundational principles:

1. **Reference:** MANIFEST.md is authoritative
2. **Test:** Does it preserve the founding commitments?
3. **Community Vote:** Public discussion → maintainer decision
4. **Fork Option:** Dissenting parties may fork with attribution

---

### **Maintainer Succession**

If original maintainers become unavailable:

1. **Continuity:** New maintainers bound by this document
2. **Verification:** Must pass Golden Artifact tests
3. **Attestation:** Must publicly commit to foundational principles

---

## VIII. The Governance Commitment

**By maintaining this system, we commit to:**

1. Never remove sacred invariants
2. Never weaken dignity protections  
3. Never make COMMIT mutable
4. Never hide semantic operations
5. Never optimize away humanity

**This is not negotiable.**

Any maintainer who cannot uphold these commitments **must step down**.

---

## IX. Final Authority

**Ultimate Authority:** The MANIFEST.md  
**Constitutional Law:** This GOVERNANCE.md  
**Executable Truth:** The Golden Artifact Test Suite

If there is ever conflict between:
- What maintainers want
- What the code currently does
- What this document requires

**This document governs.**

---

## X. Revision History

**Version 1.0** — January 1, 2026  
- Initial governance framework
- Established foundational principles
- Defined amendment process

---

**End of Governance Document**

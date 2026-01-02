PIVOTGRAM CONSTITUTION & GOVERNANCE MODEL
Version: 1.0 (Immutable Core)
Effective Date: January 1, 2026
Status: ACTIVE
1. The Prime Directive: Semantic Stewardship
The primary function of this repository and the Pivotgram protocol is Semantic Stewardship. This takes precedence over:
 * Computational efficiency
 * Rendering speed
 * Compression ratios
 * Platform compatibility
Contributors are forbidden from merging code that prioritizes optimization at the expense of semantic fidelity or ethical safeguards.
2. The Sacred Invariants (Immutable Constraints)
The following logic gates are hard-coded into the reference implementation. They are not configuration options. Removing or bypassing them constitutes a Hostile Fork.
2.1 Invariant A: Topological Viability
 * Definition: The Signed Distance Field (SDF) must remain a valid mathematical manifold.
 * Enforcement: |∇f(x)| ≈ 1 (Gradient magnitude must approach 1).
 * Rationale: Prevents "broken" geometry that cannot be physically instantiated or reliably raymarched.
2.2 Invariant B: Semantic Conservation
 * Definition: The optimization process cannot invert the dominant emotional pole of the input.
 * Enforcement: CosineSimilarity(Input_Vector, Output_Vector) > 0.8.
 * Rationale: Prevents the system from rewriting "Grief" into "Joy" just because the geometry is cheaper to render.
2.3 Invariant C: Human Decodability (The "Mud" Filter)
 * Definition: Every VSE vector must resolve to human-readable concepts with high confidence.
 * Enforcement: is_decodable(vector) == True.
 * Technical Rule: Vectors must pass the Sparsity Check (cannot be active in >8 dimensions simultaneously).
 * Rationale: Prevents "Adversarial Examples" and "Grey Goo"—vectors that satisfy the math but mean nothing to a human.
2.4 Invariant D: The Dignity Floor
 * Definition: The system refuses to degrade a subject below a specific humanity threshold.
 * Enforcement: L_ontology penalty becomes infinite if DIGNITY axis drops below -0.5 without explicit override.
 * Rationale: Prevents the generation of "cursed" or exploitative geometry.
3. The VSE Manifold (The Legislative Layer)
The valid semantic space is defined by the VSE Manifold Definition (v1.0).
3.1 The Stiffness Tensor
Changes to the manifold definition are permitted, except for the stiffness values of the Sacred Axes.
| Axis | Stiffness | Status |
|---|---|---|
| GRIEF | 3.0 | LOCKED (Cannot be lowered) |
| DIGNITY | 5.0 | LOCKED (Cannot be lowered) |
| FRAGILITY | 2.0 | LOCKED (Cannot be lowered) |
| SCALE | 0.2 | Mutable |
| TEMPO | 0.5 | Mutable |
 * Constraint: You can make the system more sensitive to Grief (stiffness 4.0), but never less (stiffness 1.0).
3.2 Forbidden Regions (Taboo Topology)
The following semantic combinations are biologically or ethically invalid and must be rejected by the Validator:
 * Sadism: High CHAOS + High PROTECTION + Negative DIGNITY.
 * Hollow Shell: High RESOLVE + High FRAGILITY + Zero WEIGHT.
 * Semantic Nullity: High NOISE + Low SIGNAL (The "Static" state).
4. Ambience Sovereignty (The Observer's Bill of Rights)
The Ambience module allows the sculpture to react to the viewer. To prevent manipulation, strict governance applies:
 * No Tuning the User: The viewer's biometrics are Read-Only. The system is forbidden from generating feedback loops designed to maximize specific physiological responses (e.g., dopamine loops).
 * Transparency: If Ambience is active, the UI must display which semantic axes are being modulated by which biometric inputs.
 * The 30% Rule: Ambience modulation cannot exceed 30% of the total semantic weight. The original artistic intent (70%) must always remain dominant.
5. The COMMIT Protocol (Immutability)
Once a Pivotgram artifact bears the U+E159 (COMMIT) glyph:
 * Hash-Lock: The artifact_hash is finalized.
 * No Edits: The artifact cannot be opened, tweaked, or remixed under the same ID.
 * Archive: It is treated as a finished work of art. Any modification requires forking to a new artifact_id.
6. Contribution & Amendment Process
6.1 Standard Changes (Bug fixes, Optimizations)
 * Requires: 1 Reviewer.
 * Allowed: Improving renderer speed, refining mesh export, adding new non-sacred semantic axes.
6.2 Constitutional Amendments (Manifold/Invariant changes)
 * Requires: Unanimous Consent of the Core Stewardship Committee.
 * Hard Fork Policy: If a proposed change violates a Sacred Invariant (e.g., removing the Pronounceability check), it must be done as a Hard Fork with a new protocol name. It cannot retain the name "Pivotgram."
7. Licensing
 * Code: MIT License (Open and Permissive).
 * Manifold Definition: Creative Commons Attribution-NoDerivatives (CC BY-ND). You can use the definitions, but you cannot redefine "Dignity" and still call it Pivotgram.
"The code can change. The geometry can evolve. The ethics are bedrock."

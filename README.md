## 📂 README.md
# SDF Blaze / Sovereign Semantics
> Meaning can be transmitted with geometric fidelity.
> 
SDF Blaze is a constitutional system for the transmission, governance, and materialization of semantic intent. It allows you to encode "meaning" (emotion, narrative, concept) into a vector format that can be reconstructed as geometry across any medium (Physical Print, Hologram, VR) without degradation or manipulation.
📖 The Core Documentation
Before using the code, understand the jurisdiction:
 * MANIFEST.md — The Founding Record. Why this exists and what it protects.
 * GOVERNANCE.md — The Constitution. The immutable laws of the VSE Manifold and Sacred Invariants.
 * PROTOCOL.md — The Pivotgram Spec. The technical definition of the wire format and opcodes.
🚀 Quick Start
1. Installation
git clone https://github.com/your-handle/sdf-blaze.git
cd sdf-blaze
pip install -r requirements.txt

2. Define a Semantic Sculpture
You don't model with triangles. You model with meaning.
from sdf_blaze import VSE_Manifold, Pivotgram

# Initialize the Governed Manifold
manifold = VSE_Manifold()

# Define the "Seed of Intent"
# (Note: Valid vectors must pass the 'Pronounceability' check)
intent = manifold.create_vector({
    'TENSION': 0.8,
    'GRIEF': 0.6,
    'DIGNITY': 0.9,  # Sacred Axis (High stiffness)
    'PROTECTION': 0.7
})

# Create the Pivotgram Artifact
artifact = Pivotgram.create(
    intent=intent,
    title="The Weeping Sentinel",
    geometry_stack=[
        ('ATOMIC', {'primitive': 'sphere'}),
        ('EXPAND', {'scale': 1.5}),
        ('SENTENCE', {'concept': 'SORROW'}) # Wraps geometry in semantic field
    ]
)

# Seal the Artifact (Immutability)
artifact.commit()

3. Materialize (Generate STL)
from sdf_blaze import Materializer

# The system validates all invariants before rendering
# If 'DIGNITY' was too low, this would raise a ConstitutionalViolationError
mesh = Materializer.generate_stl(
    artifact, 
    filename="sentinel.stl", 
    resolution=256
)
print(f"Generated sovereign object: {mesh.volume}mm³")

🏗 System Architecture
1. The VSE Manifold (/core/manifold)
The mathematical space where meaning lives. It is Riemannian (curved), meaning some semantic transitions are "expensive" (e.g., inverting Grief to Joy) and some are "cheap" (e.g., scaling size).
2. The Pivotgram Compiler (/core/compiler)
Translates high-level semantic instructions into executable Signed Distance Functions (SDFs). It enforces the "Pronounceability" constraint—ensuring no encrypted or adversarial semantics can pass.
3. The Ambience Bridge (/modules/ambience)
Optional. Allows the sculpture to react to observer biometrics in real-time.
 * Constraint: Ambience is bounded. It can modulate the work, but never manipulate the observer.
 * Transparency: All modulations are logged and visible.
4. Sacred Invariants (/core/governance)
Hard-coded checks that run before every render operation:
 * TopologicalViability: Is the geometry valid?
 * SemanticConservation: Is the emotional intent preserved?
 * DignityFloor: Is the subject treated ethically?
🤝 Contributing
This is a Governed Repository.
Pull requests are welcome, but they must adhere to the Sacred Invariants. We will not merge code that:
 * Optimizes away dignity for performance.
 * Removes human-auditability from the vector space.
 * Makes the COMMIT tag mutable.
See GOVERNANCE.md for the amendment process.
📜 License
 * Code: Apache 2.0
 * Manifold Definitions: CC BY-ND 4.0 (No Derivatives allowed on the definition of "Dignity").
"The flaw is where the humanity lives."

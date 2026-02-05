# The Corpuscle Crew™

### PICO-8 Constitutional Reference Implementation (SDF-Blaze™)

---

## Constitutional Certification

```
═══════════════════════════════════════════════════════════════
CONSTITUTIONAL CERTIFICATE
PICO-8 Reference Implementation v1.3.9 (Trust Phase)

Article I: Core Invariants              ✓ COMPLIANT
Article II: PI Compliance               ✓ COMPLIANT
Article III: Non-Negotiables             ✓ COMPLIANT
Article VII: Pathological Geometry       ✓ COMPLIANT
Article IX: Mastery Responsiveness       ✓ COMPLIANT

Token Count: ~1,500 / 8,192
Ops Budget: ~700–1,100 / 8,000 per frame
LOD Ladder: ACTIVE (CPU-governed)
Iterator Safety: VERIFIED (Deferred Deletion)
Mastery Signal: DIEGETIC (Hidden)

STATUS: CANONICAL · STABLE · LIVE
═══════════════════════════════════════════════════════════════
```

---

## Overview

**The Corpuscle Crew™** is a PICO-8 game and constitutional systems experiment built on **SDF-Blaze™**, exploring a core principle:

> **Graphics serve gameplay.
> Geometry communicates truth.
> The system responds to mastery, not numbers.**

Unlike traditional sprite-based games, *Corpuscle Crew* uses **Signed Distance Fields (SDFs)** as a *single source of truth* for:

* collision
* rendering
* animation
* environmental physics

What the player sees is *exactly* what the game simulates.

As of **v1.3.9**, the cartridge represents the **Trust Phase**:
the game no longer escalates difficulty purely through aggression, but through **environmental cooperation** that emerges when the player demonstrates sustained skill.

This cartridge functions as:

* a complete arcade game
* a reference implementation of constitutional design under extreme constraints
* a living fossil record of SDF-driven gameplay evolution

---

## How to Run

1. Download **PICO-8**
   [https://www.lexaloffle.com/pico-8.php](https://www.lexaloffle.com/pico-8.php)

2. Load the cartridge:

```
corpuscle_crew_v1_3_9_*.p8
```

3. Press **Ctrl+R** to run

---

## Controls

### Core Gameplay

* **Arrow Keys** — Move
* **Z (🅾)** — Fire
* **X (❎)** — Special ability (organ-specific)
* **🅿 / Start** — Pause (native Pico-8 menu)

> ⚠️ There are **no multi-button combos**.
> Control intent is always respected.

---

## Gameplay Structure

```
Combat Waves
   ↓
Organ Challenge (every 3 waves)
   ↓
Permanent Adaptation
   ↓
Boss Encounter (milestones)
   ↓
Return to Combat
```

### Key Concepts

* **Organ Physics:**
  Each arena represents a biological system with unique forces
  (heart pulse, lung breath, brain warp, etc.)

* **Challenges ≠ Combat:**
  Organ challenges test *physics understanding*, not DPS.

* **Bosses = Exams:**
  Bosses mutate based on HP thresholds and punish fighting the physics instead of learning them.

---

## The Trust Update (v1.3.5+)

### Hidden Mastery System

The game tracks recent performance and derives a **mastery signal** from the player’s last several waves.

This value is **never shown**.

Instead, it subtly modulates the environment:

* Heart pulses become smoother
* Lung forces grow more predictable
* Brain warps stabilize
* Visual noise reduces
* Vein density decreases

> Skilled play does not make the player stronger.
> **It makes the world calmer.**

If a player asks:

> *“Why did that feel easier this time?”*

The system has succeeded.

---

## Technical Highlights

### SDF Geometry (Single Source of Truth)

```lua
function vein_sdf(x,y,t,l)
 local pulse=0
 if l==1 then
  pulse=8*sin(x/20+t)
 elseif l>=2 then
  pulse=8*sin(x/20+t)+4*sin(x/10-t*2)+2*sin(x/5+t*3)
 end
 return (base_r+pulse) - abs(y-center_y)
end
```

The same distance function governs:

* collision resolution
* rendering
* animation
* LOD degradation

There are **no wall sprites**.
**Geometry *is* the wall.**

---

### Constitutional LOD Governor

```lua
if cpu>0.95 then lod=0      -- Static fallback
elseif cpu>0.80 then lod=1 -- Reduced motion
else lod=2 end             -- Full geometry
```

* Visual complexity degrades before control
* Input and physics remain authoritative
* LOD governs both 2D SDFs and 3D projections

---

### Boss Mutation System

Bosses mutate as health decreases:

| HP Range | Behavior         |
| -------- | ---------------- |
| 100–70%  | Stable geometry  |
| 70–40%   | Increased wobble |
| 40–20%   | Erratic mutation |
| <20%     | Core exposed     |

Bosses are **geometric problems**, not bullet sponges.

---

### Deferred Deletion (Iterator Safety)

```lua
dead_q = {}

-- mark
e.dead = true
add(dead_q, e)

-- flush
for e in all(dead_q) do del(en, e) end
dead_q = {}
```

Guarantees:

* No iterator invalidation
* No skipped entities
* Stability at extreme densities (Wave 60+)

This is foundational to long-run survivability.

---

## Design Principles (Non-Negotiable)

* No invisible walls
* No sprite-driven logic
* No stat inflation
* No UI-exposed mastery meters
* Performance degrades before control
* Physics must always be readable

---

## Porting Notes

If adapting this project to another engine:

* Preserve **distance-field geometry**
* Preserve **phase-based state machine**
* Preserve **boss mutation thresholds**
* Preserve **mastery as environmental response**
* Never separate visuals from collision logic

Particles, audio, and polish may change.
**Truth must not.**

---

## Known Issues / Future Work

* Additional boss exam variants
* Optional ceremonial mastery moments
* Further organ-specific challenge tuning
* Non-authoritative audio pass
* Documentation of SDF-Blaze authoring workflow

---

## Credits

**Design & Direction:**
John (Panicland USA)

**Constitutional Framework & Systems Architecture:**
Vivid Vox™

**Implementation & Iterative Development:**
Claude (Anthropic)

**Independent Validation & Review:**
Grok · Gemini

---

## Version History (Selected)

* **v1.0** — Fossil Record
  Initial SDF walls, crew archetypes, phase alternation

* **v1.3.2** — Stabilized Canon
  Deferred deletion, 3D sigil projection, iterator safety

* **v1.3.5** — The Trust Update
  Hidden mastery, environmental calm, diegetic feedback

* **v1.3.6–1.3.9** — Live Stability
  Boss fixes, bullet fixes, native menu integration

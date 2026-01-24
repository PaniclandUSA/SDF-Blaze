# The Corpuscle Crew™ — PICO-8 Constitutional Reference Implementation

## Constitutional Certification

═══════════════════════════════════════════════════════════════
CONSTITUTIONAL CERTIFICATE
PICO-8 Reference Implementation v1.3.2 (Stabilized Phase 3)

Article I: Core Invariants    ✓ COMPLIANT

Article II: PI Compliance    ✓ COMPLIANT

Article III: Non-Negotiables  ✓ COMPLIANT

Article VII: Pathological Geometry ✓ COMPLIANT


Token Count: ~1,350 / 8,192
Ops Budget: ~700–1,000 / 8,000 per frame
LOD Ladder: ACTIVE (3 levels, CPU-governed)
Iterator Safety: VERIFIED (Deferred Deletion)

STATUS: CANONICAL · STABLE · SHIP-READY
═══════════════════════════════════════════════════════════════


---

## Overview

The Corpuscle Crew™ is a PICO-8 game and systems experiment exploring constitutional game design:

> Graphics serve gameplay.
Geometry communicates truth.
Performance degrades gracefully before control does.



Version v1.3.2 represents the stabilized Phase 3 build, integrating:

Deferred deletion for iterator safety

A CPU-governed 3D sigil projection (icosahedral core)

Hardened SDF collision + rendering

Fully verified update/draw separation


This cartridge now functions as both a playable game and a fossil record of constitutional principles applied under extreme constraints.


---

## How to Run

1. Download PICO-8 from https://www.lexaloffle.com/pico-8.php


2. Load the cartridge file:

Corpuscle_phase3_v1.3.2.p8


3. Press Ctrl+R to run




---

## Controls

Core Gameplay

Arrow Keys — Rotate / Move

Z (🅾) — Shoot

X (❎) — Fire inoculation bolt


Defense Phase

Arrow Keys — Move placement cursor

Z (🅾) — Place tower

X (❎) — Cycle tower type

Z + X — Continue to next phase



---

## Technical Highlights

SDF Vein Walls (Single Source of Truth)

function vein_sdf(x,y,t,l)
 local pulse=0
 if l==1 then
  pulse=8*sin(x/20+t)
 elseif l>=2 then
  pulse=8*sin(x/20+t)+4*sin(x/10-t*2)+2*sin(x/5+t*3)
 end
 return (base_r+pulse) - abs(y-center_y)
end

The signed distance field is used for:

Collision resolution

Visual rendering

Organic animation

LOD-aware degradation


There are no wall sprites. Geometry is the wall.


---

## Constitutional LOD Governor

if cpu>0.95 then lod=0      -- Static fallback
elseif cpu>0.80 then lod=1  -- Reduced motion
else lod=2 end              -- Full geometry

Visual complexity degrades before gameplay responsiveness

Player input and physics remain authoritative

The same LOD governs 2D SDF walls and 3D sigil rendering



---

## Boss Mutation & Core Revelation

Boss geometry mutates as HP decreases:

HP Range	Behavior

100–70%	6 lobes, stable
70–40%	5 lobes, increased wobble
40–20%	4 lobes, erratic
<20%	3 lobes, core exposed


When the core is exposed:

A procedural icosahedral sigil appears

Pure ALU 3D projection (no sprites, no models)

2× damage to core

Projection is LOD-gated and z-clipped for safety



---

## Deferred Deletion (Iterator Safety)

v1.3.2 introduces a hardened deletion model:

dead_q = {}

-- mark
e.dead = true
add(dead_q, e)

-- flush
for e in all(dead_q) do del(en, e) end
dead_q = {}

This guarantees:

No iterator invalidation

No skipped entities

No frame-dependent crashes at high density


This change is foundational to the stability of later waves.


---

## Porting Guide

If porting this project to another platform or engine:

Preserve the phase state machine
(shooter ↔ defense ↔ boss)

Retain SDF-based walls (not tiles, not sprites)

Keep boss mutation thresholds (4 stages)

Honor crew archetype tradeoffs

Enforce frame-time guarantees before visuals

Avoid asset-driven logic (geometry must reflect state)


The React prototype may add:

Particles

Audio

Screen shake


…but must not change core logic.


---

## Known Issues / Future Work

Balance tuning for waves 7–9

Minor UX clarity for defense phase exit

Optional optimization: precomputed icosahedron edge list

Audio pass (non-authoritative, cosmetic only)



---

## Credits

Design & Direction: John (Panicland USA)

Constitutional Framework & Systems Architecture: Vox

Implementation & Iterative Development: Claude (Anthropic)

Independent Validation & Review: Grok



---

## Version History

v1.0 — Fossil Record (2025-01-23)

Initial constitutional implementation

SDF vein walls with LOD ladder

4 crew archetypes

Phase alternation

Procedural boss mutation


v1.3.1 — Phase 3 Expansion

Boss core reveal

Procedural 3D sigil (icosahedron)

CPU-gated projection


v1.3.2 — Stabilized Canon

Deferred deletion (iterator safety)

Z-clipped 3D projection

Dead-state gating across logic & draw

Production-ready stability

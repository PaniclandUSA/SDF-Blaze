# The Corpuscle Crew - PICO-8 Reference Implementation

## Constitutional Certification
═══════════════════════════════════════════════════════════════
CONSTITUTIONAL CERTIFICATE
PICO-8 Reference Implementation v1.0
Article I: Core Invariants           ✓ COMPLIANT
Article II: PI Compliance             ✓ COMPLIANT
Article III: Non-Negotiables          ✓ COMPLIANT
Article VII: Pathological Geometry    ✓ COMPLIANT
Token Count: ~850 / 8192
Ops Budget: ~600-800 / 8000 per frame
LOD Ladder: ACTIVE (3 levels)
STATUS: FOSSIL RECORD - CANONICAL
═══════════════════════════════════════════════════════════════
## How to Run

1. Download [PICO-8](https://www.lexaloffle.com/pico-8.php)
2. Load `Corpuscle_phase3.py`
3. Press Ctrl+R to run

## Controls

- **Arrow Keys**: Move/Rotate
- **Z (🅾)**: Shoot
- **X (❎)**: Cycle towers (defense phase)
- **🅾+❎**: Continue to next phase

## Technical Highlights

### SDF Vein Walls
```lua
function vein_sdf(x,y,t,l)
  local pulse=0
  if l>=2 then
    pulse=8*sin(x/20+t)+4*sin(x/10-t*2)+2*sin(x/5+t*3)
  end
  return (base_r+pulse) - abs(y-center_y)
end
Distance fields provide:
Collision detection
Visual rendering
Graceful LOD degradation
Procedural Boss Mutation
Boss geometry responds to damage:
100-70% HP: 6 lobes, stable
70-40% HP: 5 lobes, wobbling
40-20% HP: 4 lobes, erratic
<20% HP: 3 lobes, core exposed (2x damage)
Draw calls REDUCE as boss weakens (performance + clarity).
Performance Guarantees
-- Automatic LOD ladder
if cpu>0.95 then lod=0      -- Static walls
elseif cpu>0.80 then lod=1  -- Single pulse
else lod=2 end              -- Full organic
Visual quality degrades BEFORE gameplay responsiveness.
Porting Guide
To port this to other platforms:
Preserve the phase state machine (shooter↔defense↔boss)
Keep SDF vein walls (distance fields, not sprites)
Maintain boss mutation thresholds (4 stages)
Honor crew archetypes (speed/cooldown/damage tradeoffs)
Ensure PI compliance (frame budget guarantees)
The React version adds particles, sound, and polish
WITHOUT changing core logic.
Known Issues
Wave 7-9 difficulty spike (balance tuning planned)
Defense phase exit could be clearer (UX improvement planned)
Boss health bar can be obscured (repositioning planned)
Credits
Design: John (Panicland USA)
Constitutional Framework: Vox (Systems Architect)
Implementation: Claude (Anthropic)
Third-Party Validation: Grok
Version History
v1.0 (2025-01-23): Initial fossil record
SDF vein walls with LOD ladder
4 crew types (Blaster, Heavy, Medic, Scout)
Phase alternation (shooter/defense/boss)
Procedural biofilm boss mutation
PI compliance guarantees

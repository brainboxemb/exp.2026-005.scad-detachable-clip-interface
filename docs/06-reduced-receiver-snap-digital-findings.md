# Reduced receiver + snap — current digital rail/plate baseline

Status: **receiver X/Z profile retained; longitudinal Y termination reopened in PR #7**

Earlier straight-extrusion candidate source:

```text
c950b21ed24b8bd5ba9abd78ff95cff2b49c62af
```

Earlier candidate build run:

```text
35425438453
```

That run proves the straight-extrusion candidate builds as a manifold STL; it
does **not** qualify that longitudinal construction as the correct receiver.
The non-functional millimetre groove pattern remains separate from the mating
geometry.

Published preview:

```text
dev/pr-7/bld
```

Pinned QuackWorks source:

```text
e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
```

## Current concept

The experiment tests one local fixed/removable interface in two neutral carrier contexts:

```text
rail carrier       50 × 10 × 4 mm
plate carrier      50 × 20 × 6 mm
plate support      10 × 10 × 4 mm
receiver position  one local 10 × 10 mm zone
removable snap     one shared 10 mm-long part
```

The two carrier variants deliberately share the same functional receiver and
removable snap. Carrier choice is not yet a separate mechanism choice.

## Receiver geometry

The node radial mirror establishes the transverse profile:

```text
local Z 0.0 .. 1.6    width 8.6 mm
local Z 1.6 .. 2.6    ramp 8.6 -> 10.0 mm
local Z 2.6 .. 3.6    width 10.0 mm
local Z 3.6 .. 4.0    ramp 10.0 -> 9.2 mm
```

The longitudinal construction is **not qualified**. Inspection of the pinned
`openGridTileAp1()` shows two separate source mechanisms:

1. `path_extrude2d(path_tile)` for each straight edge;
2. a separate `full_tile_corners_profile` extrusion for the corner regions.

The current node STL keeps only the first mechanism as a 10 mm candidate. The
earlier 8+1+1/smoothstep version invented a different end transition. Neither
candidate may be promoted to the interface contract until the compact
straight-edge/corner translation is explicitly resolved.

## Removable snap correction

The earlier reduced nub used a simplified trapezoid. Visual review showed that the
straight middle region did not represent the OpenGrid snap well enough.

The current baseline keeps the QuackWorks normal-snap nub construction:

- 0.4 mm radial nub depth;
- source Z wedge relationship;
- separate upper and lower wedges;
- source-style rounded intersection;
- only the tangential Y extent is reduced with the 25 -> 10 mm plan scale.

The snap top is also no longer a plain rectangular slab. It uses a reduced
OpenGrid-like plan chamfer.

This keeps the PoP focused on reducing the attachment footprint without silently
replacing the reference retention shape with a different mechanism.

## OpenGrid Lite reference interpretation

The pinned QuackWorks/basic Lite reference remains:

```text
Lite receiver height        4.0 mm
basic Lite snap height      3.4 mm
arithmetic difference       0.6 mm
```

The experiment does **not** impose a derived 0.6 mm seated Z offset. Receiver
and snap are posed using the upstream CENTER anchoring.

For render interpretation, two section planes are retained:

- **solid/off-slot section** — primary overview of the continuous mating body;
- **center/flex-slot section** — technical view through the compliant click slot.

This prevents intentionally missing flex-slot material from being mistaken for
general fit clearance.

## Generated evidence

PNG includes:

- rail and plate assembled/exploded views;
- rail and plate retention sections;
- rail and plate transition sections;
- rail-versus-plate comparison;
- receiver rail and plate views;
- receiver top-view comparison;
- removable snap;
- reduced snap wall versus OpenGrid snap wall profile;
- OpenGrid Full/Lite solid overview sections;
- separate OpenGrid Full/Lite flex-slot sections.

STL includes:

- receiver rail;
- receiver plate;
- removable snap;
- receiver/profile slices;
- OpenGrid reference parts and profile slices.

The receiver and snap may include the optional compact 1 mm physical reference
grooves. They are shallow, top-surface scale references and do not replace or
define the side mating/retention geometry.

## CI result

Run `35425438453` completed successfully from exact source
`c950b21ed24b8bd5ba9abd78ff95cff2b49c62af`.

For all reduced-interface PNG renders and STL exports used by this baseline:

- OpenSCAD reports `Status: NoError`;
- top-level output is reported as a manifold 3D object.

The build publication records the exact experiment source and exact pinned
QuackWorks gitlink.

Generic runner/tooling warnings in the workflow are not reduced-interface geometry warnings.

## Digitally established

The current digital evidence establishes that:

- the receiver is local rather than a 50 mm continuous attachment profile;
- rail and plate variants use one shared mating interface;
- receiver X/Z geometry preserves the mirrored OpenGrid Lite ramps/chamfer in the reviewed transverse section;
- the removable nub now retains the source OpenGrid wedge/rounding principle
  rather than the superseded straight trapezoid;
- the OpenGrid basic Lite reference is represented as 4.0 mm receiver / 3.4 mm
  snap without an invented seated offset;
- solid and flex-slot sections are intentionally distinguished;
- all generated reduced-interface outputs build as manifold geometry;
- the current plain receiver candidate is a manifold 36-triangle straight
  extrusion before optional millimetre grooves; this is build evidence, not
  longitudinal design acceptance.

## Still open for digital design acceptance

The current receiver geometry is **not yet coherent enough to close the digital
step**. The next checkpoint is the longitudinal termination decision, followed
by regenerated receiver/snap and assembled evidence.

The detailed design walkthrough now makes the source reduction auditable rather
than relying on coarse before/after images:

- Lite receiver: source → retained slice → shared-scene recentering comparison
  → exact Lite result → profile zones;
- Lite snap nub: box → upper/lower wedges → rounding → four-side replication;
- click slots: actual removed material plus a center-section before/after view;
- node receiver: source-derived X/Z profile → compare pinned straight-edge and
  corner construction → resolve compact Y termination → final receiver.

Do not move on to later qualification to hide an unresolved base receiver/snap
geometry problem.

## Later physical qualification

After digital design acceptance, retain the neutral coupon as the qualification
fixture and determine:

- insertion/removal behaviour;
- flex survival under repeated use;
- whether the nominal interference/clearance needs explicit tolerance variants;
- whether rail or plate carrier context is preferable for later HUB75
  integration.

Those are follow-up qualification questions, not prerequisites for merging a
coherent digital design/evidence checkpoint.

The assembled digital reference uses `NODE_SNAP_SEATED_Z = 0.0`, matching the
pinned Lite reference's same-origin CENTER assembly. The 0.6 mm receiver/snap
height difference is retained only as an observation, not as a seating rule.

## Physical boundary

CAD and CI establish geometry, reproducibility and provenance. They do not
establish insertion force, removal force, fatigue, final material, printer
tolerance robustness or load capacity.

Those remain physical qualification questions.

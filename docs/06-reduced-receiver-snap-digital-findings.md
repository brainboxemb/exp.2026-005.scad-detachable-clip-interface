# Reduced receiver + snap — current digital rail/plate baseline

Status: **current digital baseline; visual acceptance and physical qualification still open**

Qualified source head:

```text
e4b3878aa0c2bf786781a02716fea77293cdcb61
```

Build run:

```text
35356649821
```

Published preview:

```text
dev/pr-4/bld
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
plate support      10 × 14 × 4 mm
receiver position  one local 10 × 10 mm zone
removable snap     one shared 10 mm-long part
```

The two carrier variants deliberately share the same functional receiver and
removable snap. Carrier choice is not yet a separate mechanism choice.

## Receiver geometry

The receiver is local rather than continuous along the 50 mm carrier.

Its source-derived X/Z relation is:

```text
local Z 0.0 .. 1.6    width 8.6 mm
local Z 1.6 .. 2.6    ramp 8.6 -> 10.0 mm
local Z 2.6 .. 3.6    width 10.0 mm
local Z 3.6 .. 4.0    inward lead-in to 9.2 mm
```

Along Y, the lower receiver profile is active over the central 8 mm and returns
to the ordinary carrier over 1 mm at each end.

The final 0.4 mm top region also narrows in plan. This is intentional centring
geometry: a part pressed down from above should be guided toward the local
receiver centre rather than pushed outward.

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

The receiver coupons may include the optional compact 1 mm physical reference
groove cross. It remains outside the mating edges and is not functional geometry.

## CI result

Run `35356649821` completed successfully from exact source
`e4b3878aa0c2bf786781a02716fea77293cdcb61`.

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
- receiver top geometry centres inward;
- the removable nub now retains the source OpenGrid wedge/rounding principle
  rather than the superseded straight trapezoid;
- the OpenGrid basic Lite reference is represented as 4.0 mm receiver / 3.4 mm
  snap without an invented seated offset;
- solid and flex-slot sections are intentionally distinguished;
- all generated reduced-interface outputs build as manifold geometry.

## Still open before acceptance

Digital success is not yet final acceptance.

Still required:

1. visual inspection of the corrected receiver top, snap profile and assembled
   rail/plate renders;
2. confirm that the reduced snap still looks mechanically coherent relative to
   the pinned OpenGrid profile;
3. print neutral coupons;
4. establish insertion/removal behaviour and whether the flex region survives
   repeated use;
5. determine whether the nominal interference/clearance needs explicit tolerance
   variants;
6. decide whether rail or plate carrier context is preferable for later HUB75
   integration.

Do not move on to tolerance or carrier qualification to bypass an unresolved
base receiver/snap geometry problem.

## Physical boundary

CAD and CI establish geometry, reproducibility and provenance. They do not
establish insertion force, removal force, fatigue, final material, printer
tolerance robustness or load capacity.

Those remain physical qualification questions.

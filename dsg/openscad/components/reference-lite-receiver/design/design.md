# OpenGrid Lite receiver reference — design

<!-- scad-render-defaults
engine: openscad
source: reference_lite_receiver_render.scad
module: reference_lite_receiver_design
vpr: [65, 0, 35]
-->

## Purpose

This component is the **pinned source reference** for the fixed side of the
experiment. It is not experiment-owned geometry.

Source:

```text
AndyLevesque/QuackWorks
commit e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
openGrid/openGrid.scad
```

The repository-level upstream licence is CC BY-NC-SA 4.0. Attribution and the
exact source boundary are recorded in `docs/00-source-provenance.md`.

## Complete Lite receiver

The Lite receiver is a 1 × 1 OpenGrid Lite board cell using the upstream
defaults. Its overall thickness is 4.0 mm.

<!-- scad-render
view: final
-->

## Source profile used by the experiment

For the 4.0 mm Lite height the relevant internal opening evolves as:

```text
local Z          opening width
0.0 .. 1.6       26.4 mm
1.6 .. 2.6       26.4 -> 25.0 mm
2.6 .. 3.6       25.0 mm
3.6 .. 4.0       25.0 -> 25.8 mm
```

The experiment derives its reduced fixed-side profile from this relationship;
the reference itself is not modified.

A solid/off-slot section is the primary profile view because it shows the
continuous mating body without the flex-slot void from the snap confusing the
comparison.

<!-- scad-render
view: solid-profile
vpr: [90, 0, 0]
-->

## Flex-plane reference

The centre-plane section is retained as technical evidence for comparisons with
the snap/flex system.

<!-- scad-render
view: flex-profile
vpr: [90, 0, 0]
-->

## Boundary

This component exists only to make the upstream reference readable and
reproducible. Reduced dimensions, mirrored retention geometry, carrier
integration and tolerance choices belong to the experiment-owned receiver and
snap components.

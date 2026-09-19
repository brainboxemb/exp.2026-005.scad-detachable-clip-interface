# Node receiver — design

## Role in the two-stage model

This component is a **stage-2 reference implementation**. The shared mating
geometry is specified separately in
[`specification/specification.md`](../../../specification/specification.md).
This document explains how this particular minimal part realizes that contract.
Implementation details described here are not automatically interface requirements.


<!-- scad-render-defaults
engine: openscad
source: node_receiver_render.scad
module: node_receiver_design
vpr: [68, 0, 28]
-->

## Design intent

The receiver is the fixed half of the reduced node interface. It is evaluated
as a standalone object before rail or plate integration.

The pinned OpenGrid source establishes the transverse mating profile and keeps
its straight edge separate from the corner construction:
`path_extrude2d()` builds the edge while `full_tile_corners_profile` adds the
corners.

Across the complete retained Lite height, the source straight edge has a
minimum half-span of **6.923045 mm** before corner material begins. A centred
10 mm receiver uses 5.000000 mm per side, so its crop planes remain
**1.923045 mm inside the straight source region at both ends**.

The stage-2 receiver is therefore a finite crop of the source straight edge.
It does not reproduce, scale or blend the source corners.

## Geometry provenance

| Geometry | Pinned OpenGrid Lite | Node receiver | Provenance |
| --- | ---: | ---: | --- |
| receiver height | 4.0 mm | 4.0 mm | upstream retained |
| capture width | 25.0 mm | 10.0 mm | experiment target |
| lower outer width | 26.4 mm | 8.6 mm | derived: `35.0 - 26.4` |
| central capture width | 25.0 mm | 10.0 mm | derived around chosen 10.0 mm target |
| top width | 25.8 mm | 9.2 mm | derived: `35.0 - 25.8` |
| lower constant Z band | 0.0 .. 1.6 mm | 0.0 .. 1.6 mm | upstream retained |
| lower ramp Z band | 1.6 .. 2.6 mm | 1.6 .. 2.6 mm | upstream retained |
| capture Z band | 2.6 .. 3.6 mm | 2.6 .. 3.6 mm | upstream retained |
| top chamfer Z band | 3.6 .. 4.0 mm | 3.6 .. 4.0 mm | upstream retained |
| local Y footprint | edge + separate corner construction | centred 10.0 mm straight-edge crop | **validated stage-2 choice** |
| Y termination | source corner starts outside crop | crop planes at Y = +/-5.0 mm | **stage-2 implementation choice** |

The radial mirror is:

```text
mirror sum = source capture width + target capture width
           = 25.0 + 10.0
           = 35.0 mm

node width = 35.0 - upstream opening width
```

The radial widths and Z bands are contract-facing. The finite Y construction
is stage-2-only: the reference receiver takes the middle 10 mm of the validated
straight source region and ends it at two explicit crop planes.

## Step 1 — inspect the complete derived X/Z profile

<!-- scad-render
view: profile
vpr: [90, 0, 0]
-->

This is a 1 mm-thick centre slice of the **actual production receiver**, not a
redrawn diagram.

The profile must visibly contain all four Lite-derived zones:

```text
Z 0.0 .. 1.6     width 8.6 mm
Z 1.6 .. 2.6     ramp 8.6 -> 10.0 mm
Z 2.6 .. 3.6     width 10.0 mm
Z 3.6 .. 4.0     ramp 10.0 -> 9.2 mm
```

The lower 1.6..2.6 ramp and upper 3.6..4.0 chamfer are both part of **one
profile**. The upper chamfer is not a separate Y-dependent guide operation.

## Step 2 — validate the finite straight-edge crop

The 10 mm `path_extrude2d()` is accepted for a source-derived reason:

```text
minimum source straight half-span   6.923045 mm
required crop half-length           5.000000 mm
margin to source corner start       1.923045 mm per end
```

The limiting source band is Lite-local Z=0.0..1.6 mm. Every later profile band
increases the available straight span.

```text
drawing/03-opengrid-straight-crop-proof.svg
drawing/03-opengrid-straight-crop-proof.png
```

<!-- scad-render
view: profile-vs-extrusion
-->

The node uses a local middle crop from one OpenGrid straight edge and ends it at
two crop planes. No scaled source corner or invented Y blend is part of this
reference implementation.

## Step 3 — inspect the functional receiver

<!-- scad-render
view: plain
-->

This is the accepted digital stage-2 geometry without the optional scale
marks. Its Y-end treatment is the validated centred straight-edge crop.
Physical fit and retention remain separate qualification questions.

## Step 4 — optional 1 mm reference grooves

The millimetre pattern is physical but non-functional. Existing receiver
geometry is grey; groove cutters are red:

<!-- scad-render
view: pattern-cutters
-->

The pattern does not define any mating dimension.

## Final design object

<!-- scad-render
view: final
-->

This standalone object is the stage-2 fixed-side reference implementation. Its
X/Z profile is contract-facing; its finite 10 mm Y crop is implementation-facing
and does not become a shared interface requirement.

## Integration boundary

Consumers must preserve the established X/Z mating profile. The 10 mm crop is
a validated reference-implementation choice, not a normative requirement for
all consumers.


## Reference implementation drawing

The same receiver profile is also exported as a true 2D SVG drawing. This is
still a legacy OpenSCAD-only sheet while the drawing migration is incremental;
its small compatibility dimension helper is repository-local and has no
external OpenSCAD drawing-library dependency. The geometry still comes directly
from the production receiver profile.

<!-- scad-render
source: node_receiver_drawing.scad
module: node_receiver_profile_drawing
format: svg
image: 06-dimensioned-retention-profile.svg
vpr: null
-->

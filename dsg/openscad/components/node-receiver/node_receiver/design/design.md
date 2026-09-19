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

The pinned OpenGrid source establishes the transverse mating profile, but it
does **not** reduce to one longitudinal construction rule. In
`openGridTileAp1()` the straight edge is generated with
`path_extrude2d()`, while the corner/termination region is separate geometry
from `full_tile_corners_profile`.

For the node receiver we therefore know the X/Z profile, but we have not yet
established how that profile should terminate inside the compact Y footprint.
Both previously tried interpretations are non-authoritative:

- 8+1+1 mm / smooth radial-depth blending;
- unchanged straight 10 mm profile extrusion.

The current code still contains the straight-extrusion candidate so it can be
inspected, but it is **not accepted design authority**.

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
| local Y footprint | edge + separate corner construction | 10.0 mm candidate | **experiment choice under review** |
| Y termination | separate source corner geometry | unresolved | **open design question** |

The radial mirror is:

```text
mirror sum = source capture width + target capture width
           = 25.0 + 10.0
           = 35.0 mm

node width = 35.0 - upstream opening width
```

Only the radial widths and Z bands above are currently established. The source
straight-edge and corner constructions must still be translated deliberately
into the compact node termination.

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

## Step 2 — inspect the current longitudinal candidate

The current implementation uses a 10 mm straight `path_extrude2d()` only as
a **candidate**. This view is useful precisely because it makes that assumption
visible for review:

<!-- scad-render
view: profile-vs-extrusion
-->

Do not infer acceptance from this render. Upstream OpenGrid uses this mechanism
for a straight edge but adds separate corner geometry at the edge ends. The
node PoP still needs an explicit decision about what the compact equivalent of
that termination should be.

## Step 3 — inspect the functional receiver

<!-- scad-render
view: plain
-->

This is the current candidate geometry without the optional scale marks. It is
useful comparison evidence, but its Y-end treatment is not yet accepted as the
final receiver definition.

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

This standalone object is the current stage-2 fixed-side **candidate**. Its X/Z
profile is contract-facing; its Y termination remains under review.

## Integration boundary

Consumers must preserve the established X/Z mating profile. No consumer should
copy the current straight Y termination as if it were normative until this
experiment has explicitly resolved the local end geometry.


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

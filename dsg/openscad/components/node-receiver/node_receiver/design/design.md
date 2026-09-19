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

The receiver is the fixed half of the **stage-2 minimal reference
implementation**. It implements the stage-1 interface specification rather
than defining the contract itself.

The fixed-side mating patch has two independent geometric descriptions:

```text
transverse X/Z section
        +
longitudinal Y extent / end blend
        =
complete local tongue
```

The current PoP tongue is 10 mm long. The full source-derived X/Z profile is
active over the central 8 mm. Over the final 1 mm at each Y end, only the
radial cut depth blends smoothly back to the ordinary 10 mm-wide envelope. The
top plane stays at Z=4 mm.

This 8 + 1 + 1 mm construction is part of the current interface specification;
it is not merely carrier decoration.

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
| longitudinal patch length | tile edge/corner path | 10.0 mm | current PoP contract |
| full-depth active length | straight-edge region | 8.0 mm | current PoP contract |
| end transition | source corner/termination behaviour | 1.0 mm per end | experiment translation |
| Y profile variation | edge/corner dependent | smooth radial-depth blend | experiment translation |

The radial mirror is:

```text
mirror sum = source capture width + target capture width
           = 25.0 + 10.0
           = 35.0 mm

node width = 35.0 - upstream opening width
```

Only the radial widths are transformed. The source Z bands and straight-edge
extrusion principle remain unchanged.

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

## Step 2 — define the longitudinal tongue

The centre 8 mm uses the full X/Z profile. The final 1 mm at each end blends
the radial recess depth back to zero:

```text
Y=-5    -4                         +4    +5
  0% -> 100% ===================== 100% -> 0%
       1 mm        8 mm active        1 mm
```

The normalized depth factor is the same function published by the
specification:

```text
depth(t) = 1 - (3 t^2 - 2 t^3)
```

This gives zero slope at both ends of the transition. The number of sampled
sections used by OpenSCAD is tessellation only.

The plan view in the specification is the primary drawing for this behaviour;
a centre X/Z profile alone is not sufficient evidence.

## Step 3 — inspect the functional receiver

<!-- scad-render
view: plain
-->

The complete receiver must show the local tongue terminating cleanly inside its
10 mm footprint. There must be no invented 14 mm support extension and no
vertical seam where the 8 mm active region enters the 1 mm end blend.

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

This standalone object is the minimal fixed-side **reference implementation**.
The stage-1 interface definition lives in the shared specification.

## Integration boundary

Consumers may place the receiver on a rail, plate, HUB75 coupler or another
carrier, but integration must preserve both the X/Z mating section and the
specified 10 mm longitudinal tongue including its 1 mm end blends. Geometry
outside that local patch remains an integration choice.


## Reference implementation drawing

The same receiver profile is also exported as a true 2D SVG drawing. The
drawing uses the installed `openscad-new-dimensions` library for dimension
lines and takes its geometry directly from the production receiver profile.

<!-- scad-render
source: node_receiver_drawing.scad
module: node_receiver_profile_drawing
format: svg
image: 06-dimensioned-retention-profile.svg
vpr: null
-->

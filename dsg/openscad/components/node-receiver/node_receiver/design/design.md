# Node receiver — design

<!-- scad-render-defaults
engine: openscad
source: node_receiver_render.scad
module: node_receiver_design
vpr: [68, 0, 28]
-->

## Design intent

The receiver is the fixed half of the reduced node interface. It is evaluated
as a standalone object before rail or plate integration.

The pinned OpenGrid source establishes the construction principle:

```text
one 2D radial/Z edge profile
        ↓
BOSL2 path_extrude2d() along a straight edge
```

OpenGrid Lite does not invent another profile. It keeps the upper 4.0 mm of the
same Full receiver geometry. The node receiver therefore uses the same basic
construction: first derive one X/Z profile from the pinned Lite profile, then
extrude that profile unchanged along a straight local path.

There is deliberately **no 8+1 mm Y transition, smoothstep fade, polyhedron
end treatment or separate top-guide cutter** in the receiver baseline.

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
| straight-edge/path length | tile edge | 10.0 mm | **experiment choice** |
| Y profile variation | none on straight edge | none | construction principle retained |

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

## Step 2 — extrude that profile unchanged along 10 mm

OpenGrid uses BOSL2 `path_extrude2d()` for its straight tile edges. The node
receiver uses the same construction principle with a 10 mm experiment path:

```openscad
path = [
    [0,  NODE_RECEIVER_BLOCK_LENGTH / 2],
    [0, -NODE_RECEIVER_BLOCK_LENGTH / 2]
];

path_extrude2d(path)
    polygon(points = _node_receiver_profile_points());
```

The profile is constant at every Y position along this path.

The next view shows the centre profile on the left and the full extrusion on the
right:

<!-- scad-render
view: profile-vs-extrusion
-->

There should be no fan of small STL facets, no Y-fade, no end wedge and no
change in the X/Z mating profile near the 10 mm ends. Flat end caps merely stop
the chosen coupon path.

## Step 3 — inspect the functional receiver

<!-- scad-render
view: plain
-->

This is the complete mating geometry without the optional scale marks.

The 10 mm length is a PoP choice. If later carrier integration needs a blend
between this local profile and surrounding material, that is a **separate
carrier-integration question** and must not be hidden inside the receiver
definition.

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

This standalone object — not a rail or plate — is the fixed-side interface
definition.

## Integration boundary

Consumers may place the receiver on a rail, plate, HUB75 coupler or another
carrier, but integration must preserve this X/Z mating profile. Any carrier-side
transition at the two ends of the 10 mm coupon is an explicit later design
choice, not part of the OpenGrid-derived receiver baseline.

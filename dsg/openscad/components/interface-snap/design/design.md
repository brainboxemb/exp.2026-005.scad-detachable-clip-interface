# Reduced detachable snap — design

<!-- scad-render-defaults
engine: openscad
source: interface_snap_render.scad
module: interface_snap_design
vpr: [68, 0, 35]
-->

## Design intent

The snap is the removable half of the interface. It is designed independently
from rail and plate examples.

The reduction keeps the functional roles of the pinned OpenGrid Lite snap:

- a shaped body outline;
- flexible +/-X walls;
- shaped inward retention nubs;
- click/flex slots that create compliance;
- a top tying both walls together.

Only the +/-X walls retain. The Y ends stay open.

## Step 1 — build the two retaining walls

<!-- scad-render
view: side-walls
-->

The wall pair is cut from one coherent clipped-corner envelope. This avoids the
earlier problem where the top and lower body had visibly different outer angles.

The outer envelope uses one reduced chamfer value:

```openscad
AT01_SNAP_CORE_ROUNDING = min(
    AT01_SOURCE_CORE_ROUNDING * AT01_PLAN_SCALE,
    AT01_SNAP_WALL / 2
);

AT01_SNAP_TOP_ROUNDING = AT01_SNAP_CORE_ROUNDING;
```

Because the wall is 2.0 mm thick, the chamfer is capped at 1.0 mm. The end
therefore keeps both a 45-degree section and a visible straight section.

## Step 2 — add the OpenGrid-derived inward nubs

Existing walls are grey; the two nubs added in this step are red.

<!-- scad-render
view: nubs
-->

The nub is intentionally **not** a hand-drawn trapezoid. The first reduction did
that and produced a visually wrong straight middle. The current geometry keeps
the upstream construction principle: bounding body minus two wedges,
intersected with a rounded cylinder, then mirrored inward.

The essential operation is:

```openscad
intersection() {
    difference() {
        cuboid([nub_d, nub_w, ...]);
        wedge([nub_w, nub_d, top_wedge_h]);
        wedge([nub_w, 0.4, bot_wedge_h]);
    }

    scale([1, source_round_scale_y, 1])
        cyl(r = source_round_r, h = 2.01);
}
```

Only the tangential Y dimension is scaled to the 10 mm experiment. The source
radial depth and Z wedge relationship stay intact.

## Step 3 — tie the walls together with the top

The top added in this step is red.

<!-- scad-render
view: top
-->

It uses the same outer chamfer as the core/walls so the outside contour remains
continuous from bottom to top.

```openscad
cuboid(
    [
        AT01_SNAP_OUTER_WIDTH,
        AT01_SNAP_LENGTH,
        AT01_SNAP_TOP
    ],
    rounding = AT01_SNAP_TOP_ROUNDING,
    edges = "Z",
    $fn = 2
);
```

The `$fn=2` here is intentional: this is a straight clipped corner, not a
rounded high-facet curve.

## Step 4 — cut the flex/click slots

Before subtraction the solid body is shown grey; the cutters are red.

<!-- scad-render
view: slot-cutters
-->

The main click slot keeps the upstream 0.6 mm radial width and 0.3 mm rounding.
The wall stack is therefore:

```text
inside
0.7 mm  nub-bearing flex tongue
0.6 mm  click slot
0.7 mm  outer support
------------------------------
2.0 mm  total wall
outside
```

The key slot placement is:

```openscad
translate([
    inner + AT01_CLICK_SLOT_X_FROM_INNER,
    0,
    AT01_CLICK_SLOT_HEIGHT / 2
])
    cuboid(
        [
            AT01_CLICK_SLOT_RADIAL,
            AT01_CLICK_SLOT_LENGTH_Y,
            AT01_CLICK_SLOT_HEIGHT
        ],
        rounding = AT01_CLICK_SLOT_ROUNDING,
        edges = "Z"
    );
```

The long slot remains basically straight by design. It creates flex; it is not
supposed to mimic the receiver profile.

## Step 5 — inspect the functional snap without reference marks

<!-- scad-render
view: plain
-->

At this point the mechanical snap is complete. This is the view used to judge
body continuity, nub shape and slot placement without the scale pattern
distracting from them.

## Retention profile

<!-- scad-render
view: profile
vpr: [90, 0, 0]
-->

The nominal mirrored relationship is:

```text
receiver capture width   10.0 mm
snap inner body width    10.2 mm
nub opening               9.4 mm
nub protrusion            0.4 mm per side
```

This gives 0.1 mm nominal body clearance per side and temporary nub
interference while crossing the receiver capture band.

## Step 6 — add the optional 1 mm reference grooves

The physical groove cutters are red:

<!-- scad-render
view: pattern-cutters
-->

Receiver and snap intentionally use the same helper so the visual scale is
directly comparable.

## Final design object

<!-- scad-render
view: final
-->

The final force, fatigue life, best material and final tolerance still require
printed coupons. A clean CAD relationship is necessary evidence, not physical
qualification.

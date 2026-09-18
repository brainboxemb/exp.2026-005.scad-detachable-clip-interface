# OpenGrid Lite receiver — design

<!-- scad-render-defaults
engine: openscad
source: opengrid_lite_receiver_render.scad
module: opengrid_lite_receiver_design
vpr: [65, 0, 35]
-->

## Purpose and source boundary

This directory explains the pinned OpenGrid Lite receiver as a design object.
It does **not** modify the upstream geometry.

Pinned source:

```text
AndyLevesque/QuackWorks
commit e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
openGrid/openGrid.scad
```

The source/provenance boundary and CC BY-NC-SA 4.0 licence are recorded in
`docs/00-source-provenance.md`.

The useful thing to understand is that Lite is not an unrelated hand-drawn
profile. It is extracted from the upper part of the 6.8 mm Full receiver.

## Step 1 — start from the Full 6.8 mm source cell

<!-- scad-render
view: full-source
-->

The design helper calls the same upstream Full receiver:

```openscad
openGrid(
    Board_Width = 1,
    Board_Height = 1,
    anchor = CENTER
);
```

At this point the cell is still the complete Full receiver.

## Step 2 — identify the upper 4.0 mm that Lite keeps

The Full source is grey. The part retained by Lite is red:

<!-- scad-render
view: retained-top
-->

With the Full cell centered on Z=0, its vertical range is:

```text
Full:  -3.4 .. +3.4 mm
Lite source region:
       -0.6 .. +3.4 mm
       ----------------
        4.0 mm retained
```

The analysis helper visualizes exactly that intersection:

```openscad
intersection() {
    opengrid_lite_receiver_design_full_source();

    translate([-20, -20, -0.6])
        cube([40, 40, 4.0]);
}
```

The upstream code performs the same operation with `top_half()` and then
re-centers the result. The essential source sequence is:

```openscad
down(Lite_Tile_Thickness / 2)
    down(Tile_Thickness - Lite_Tile_Thickness)
        top_half(
            z = Tile_Thickness - Lite_Tile_Thickness,
            s = ...
        )
            openGrid(... anchor = BOT);
```

That is the important design relationship: Lite is the top slice of the Full
receiver, not a separately invented mating profile.

## Step 3 — isolate the retained 4.0 mm slice

The overlay above explains which region survives. The next view shows only that
exact retained intersection, still in the Full receiver's original coordinates:

<!-- scad-render
view: retained-top-only
-->

Nothing is redrawn here; it is the same intersection from Step 2 without the
grey Full receiver around it.

## Step 4 — re-center the retained slice

The retained region spans `Z=-0.6..+3.4`, so its centre is at `Z=+1.4`.
Moving it down by 1.4 mm makes the Lite extraction itself centred around Z=0.
A standalone render would hide that translation through auto-centering, so the
design evidence deliberately shows **raw on the left and re-centered on the
right in one shared scene**:

<!-- scad-render
view: recentering-compare
-->

The explanatory operation itself is simply:

```openscad
translate([0, 0, -1.4])
    opengrid_lite_receiver_design_retained_top_raw();
```

The relative vertical shift in the shared scene is the evidence for this step;
two separately auto-centered PNGs are not.

## Step 5 — compare the extraction with the exact upstream Lite result

The extracted/re-centered source region is shown on the left and the exact
pinned `openGridLite()` result on the right:

<!-- scad-render
view: recentered-compare
-->

This comparison is the check that the explanatory extraction still represents
the source relationship rather than an invented replacement implementation.

The authoritative final state remains the exact pinned module:

<!-- scad-render
view: lite-result
-->

```openscad
module opengrid_lite_receiver_build() {
    opengrid_lite_receiver();
}
```

## Step 6 — inspect the continuous wall profile

<!-- scad-render
view: solid-profile
vpr: [90, 0, 0]
-->

The solid/off-slot section makes the mating profile easiest to read.

For the 4.0 mm Lite section the relevant opening widths are:

```text
local Z          opening width
0.0 .. 1.6       26.4 mm
1.6 .. 2.6       26.4 -> 25.0 mm
2.6 .. 3.6       25.0 mm
3.6 .. 4.0       25.0 -> 25.8 mm
```

Those values come from the Full tile profile constants:

```openscad
Inside_Grid_Top_Chamfer    = 0.4;
Inside_Grid_Middle_Chamfer = 1.0;
Top_Capture_Initial_Inset  = 2.4;

Tile_Inner_Size = 25.0;
insideExtrusion = 0.7;
```

The exact upstream profile is longer than the short fragment above, but these
are the dimensions that create the Lite mating zones used by the node
derivation.

## Step 7 — make the four Lite profile zones visible

The exact Lite section is now split into four colored Z bands. No geometry is
changed; this is only an explanatory view.

<!-- scad-render
view: profile-zones
vpr: [90, 0, 0]
-->

The two transition zones are the important ones:

- **1.6 .. 2.6 mm** — moves from 26.4 mm to the 25.0 mm capture width;
- **3.6 .. 4.0 mm** — opens from 25.0 mm to 25.8 mm at the top.

Those are the two slopes later mirrored into the node receiver.

The analysis helper uses intersections with the exact source profile:

```openscad
module _opengrid_lite_receiver_profile_band(z0, z1) {
    intersection() {
        opengrid_lite_receiver_profile_view(false);
        translate([-40, -10, z0])
            cube([80, 20, z1 - z0]);
    }
}
```

So the colored bands are not redrawn approximations.

## Step 8 — inspect the centre-plane section as technical evidence

<!-- scad-render
view: flex-profile
vpr: [90, 0, 0]
-->

For the receiver this is not a flex feature, but it is kept because the matching
OpenGrid snap is also inspected through the same plane. That makes later
receiver/snap comparison consistent.

## Derivation boundary

The OpenGrid Lite receiver ends here. The node receiver may mirror the
relationship and reduce it to a local two-sided interface, but this pinned
source object remains unchanged.

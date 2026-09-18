# OpenGrid Lite receiver — design

<!-- scad-render-defaults
engine: openscad
source: opengrid_lite_receiver_render.scad
module: opengrid_lite_receiver_design
vpr: [65, 0, 35]
-->

## Why this reference exists

This component is the pinned fixed-side source reference for the experiment.
Nothing in this directory is allowed to silently “improve” the upstream
geometry.

Pinned source:

```text
AndyLevesque/QuackWorks
commit e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
openGrid/openGrid.scad
```

The source/provenance boundary and CC BY-NC-SA 4.0 licence are recorded in
`docs/00-source-provenance.md`.

## Step 1 — inspect the complete Lite cell

<!-- scad-render
view: final
-->

The Lite board is 4.0 mm thick. QuackWorks does not define a separate unrelated
Lite profile; it takes the upper Lite portion from the normal OpenGrid tile
construction.

The important source idea can be summarized as:

```openscad
openGridLite(...)
    -> keep the top 4.0 mm of openGrid(...)
```

That matters because our reduced receiver must be derived from the same profile
chain rather than from a hand-drawn approximation.

## Step 2 — inspect the continuous wall section

<!-- scad-render
view: solid-profile
vpr: [90, 0, 0]
-->

The solid/off-slot plane is the clearest profile for reading the receiver wall.
The relevant Lite opening widths are:

```text
local Z          opening width
0.0 .. 1.6       26.4 mm
1.6 .. 2.6       26.4 -> 25.0 mm
2.6 .. 3.6       25.0 mm
3.6 .. 4.0       25.0 -> 25.8 mm
```

These four zones come from the same profile constants used by the full board.
In simplified form the source profile logic is:

```openscad
top_chamfer     = 0.4;
middle_chamfer  = 1.0;
capture_inset   = 2.4;

profile = [
    ...,
    [outside + inside, capture_inset - middle_chamfer],
    [outside,          capture_inset],
    ...,
    [outside + inside, thickness - top_chamfer],
    [outside + inside - top_chamfer, thickness]
];
```

The experiment uses the resulting dimensions, not this simplified snippet, as
the source of truth.

## Step 3 — make the four source zones visible

The exact receiver section is split into the four Z zones below. This is a
visual explanation only; no geometry is altered.

<!-- scad-render
view: profile-zones
vpr: [90, 0, 0]
-->

The red bands are the two transitions that matter most to the reduction:

- local Z=1.6..2.6: the wall moves toward the 25.0 mm capture width;
- local Z=3.6..4.0: the top opens back to 25.8 mm.

Those two slopes become the lower retention ramp and upper insertion lead-in
when radially mirrored into the reduced receiver.

## Step 4 — keep the centre-plane evidence

<!-- scad-render
view: flex-profile
vpr: [90, 0, 0]
-->

For the receiver itself this plane is not a flex feature, but it is retained
because the matching snap reference is also inspected through this plane. That
keeps later receiver/snap comparisons honest.

## Derivation boundary

The reference ends here. The reduced receiver may mirror and scale the
relationship, but the pinned Lite cell itself remains untouched.

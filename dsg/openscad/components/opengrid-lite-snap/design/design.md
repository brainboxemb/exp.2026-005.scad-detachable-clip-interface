# OpenGrid Lite snap — design

<!-- scad-render-defaults
engine: openscad
source: opengrid_lite_snap_render.scad
module: opengrid_lite_snap_design
vpr: [65, 0, 35]
-->

## Why this reference exists

This component is the pinned removable-side source reference used to understand
which shapes in OpenGrid are structural, which provide flex, and which create
retention.

Pinned source:

```text
AndyLevesque/QuackWorks
commit e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
openGrid/opengrid-snap.scad
```

## Step 1 — inspect the complete Lite snap

<!-- scad-render
view: final
-->

The pinned QuackWorks Lite snap is 3.4 mm high and 24.8 mm wide. The top view is
not a plain square: both the core and top are clipped/chamfered.

The source construction is roughly:

```openscad
w       = 24.8;
core_h  = 3.0;
top_h   = 0.4;

core = cuboid([w,w,core_h], rounding=4.81837, $fn=2);
top  = cuboid([w,w,top_h],  rounding=3.262743, $fn=2);
```

The reduced snap later keeps the same clipped-corner design language rather
than replacing it with a rectangular slab.

## Step 2 — separate the principal source layers

The exact final snap is split into its main 3.0 mm core region and 0.4 mm top
region:

<!-- scad-render
view: source-layers
-->

The red upper band is only 0.4 mm. This is why the old impression that the Lite
snap should simply fill the entire 4.0 mm receiver height was misleading: the
pinned source really is a 3.4 mm snap.

The source also adds a shaped top nub inside the upper core region. So “core +
top” describes the height stack, not two featureless boxes.

## Step 3 — understand the retention nub

The normal nub is not a trapezoid. Its source construction combines two wedge
subtractions with a rounded-cylinder intersection.

A compact equivalent description is:

```openscad
nub =
    intersection(
        box
          - top_wedge
          - bottom_wedge,
        rounded_cylinder
    );
```

Important source dimensions used by the experiment are:

```text
nub radial depth       0.4 mm
nub width             11.0 mm
upper wedge height     0.6 mm
lower wedge height     0.6 mm
rounded radius        13.025 mm
```

This is the reason the reduced snap now keeps a bulb-like shaped nub instead of
the earlier straight-sided approximation.

## Step 4 — inspect the continuous wall profile

<!-- scad-render
view: solid-profile
vpr: [90, 0, 0]
-->

This section avoids the long click slot and shows the body/nub relationship
without missing material.

## Step 5 — inspect the flex-slot plane

<!-- scad-render
view: flex-profile
vpr: [90, 0, 0]
-->

The long slot is deliberately simple. The important source dimensions are:

```text
slot radial width       0.6 mm
slot rounding           0.3 mm
slot centre             1.0 mm inward from body face
```

That leaves a 0.7 mm nub-bearing flex tongue at the body edge:

```text
12.4 - (11.4 + 0.6 / 2) = 0.7 mm
```

The slot creates compliance; the shaped nub creates retention. Those are two
different jobs and remain separate in the reduced design.

## Derivation boundary

The experiment may reduce the snap to two active walls and scale its tangential
length, but it should preserve these source roles before introducing tolerance
variants.

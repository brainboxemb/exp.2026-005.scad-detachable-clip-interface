# OpenGrid Lite snap reference — design

<!-- scad-render-defaults
engine: openscad
source: reference_lite_snap_render.scad
module: reference_lite_snap_design
vpr: [65, 0, 35]
-->

## Purpose

This component is the **pinned removable-side source reference** used to
understand the OpenGrid Lite retention and flex geometry.

Source:

```text
AndyLevesque/QuackWorks
commit e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
openGrid/opengrid-snap.scad
```

The upstream repository uses CC BY-NC-SA 4.0. The exact attribution/provenance
boundary is recorded in `docs/00-source-provenance.md`.

## Complete Lite snap

The basic QuackWorks Lite snap is 3.4 mm high. Its plan form is deliberately
non-square: the core/top use clipped/chamfered corners.

<!-- scad-render
view: final
-->

The height is composed by the upstream model from a 3.0 mm Lite core and a
0.4 mm top layer. This does not mean the body is a pair of plain rectangular
slabs; both layers have their own plan-form construction.

## Continuous wall profile

The solid/off-slot profile shows the body and retention nub without cutting
through the long flex slot.

<!-- scad-render
view: solid-profile
vpr: [90, 0, 0]
-->

## Flex slot and nub

The centre plane intentionally crosses the click/flex slot. The slot itself is
largely straight; its job is to let the nub-bearing wall flex. Retention is
created by the shaped nub, not by making the slot match the receiver profile.

<!-- scad-render
view: flex-profile
vpr: [90, 0, 0]
-->

The experiment-owned reduced snap should preserve these functional roles before
changing dimensions: body outline, flex region, and shaped nub remain separate
design concerns.

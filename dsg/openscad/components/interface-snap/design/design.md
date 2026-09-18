# Reduced detachable snap — design

<!-- scad-render-defaults
engine: openscad
source: interface_snap_render.scad
module: interface_snap_design
vpr: [68, 0, 35]
-->

## Purpose

This is the **primary removable-side experiment object**. It is independent of
the rail and plate examples.

Its functional target is a compact two-sided reduction of the pinned OpenGrid
Lite snap relationship.

<!-- scad-render
view: final
-->

## Plan form

The snap is 10 mm long and uses a coherent clipped-corner outline inspired by
the Lite reference. The reduced chamfer is deliberately capped so the 2 mm wall
retains both a 45-degree corner and a visible straight segment.

The top and core use the same reduced outline so the outside face does not kink
between layers.

## Flex and retention

Only the +/-X walls retain and flex. The long click slot remains a straight
compliance feature; the inward nub carries the shaped retention geometry.

The nub keeps the QuackWorks normal-snap construction principle: upper/lower
wedges plus rounded intersection rather than the superseded straight
trapezoid.

<!-- scad-render
view: profile
vpr: [90, 0, 0]
-->

## Millimetre reference grooves

The same optional shallow 1 mm reference pattern used by the receiver is also
available on the snap top.

<!-- scad-render
view: plain
-->

## Integration boundary

Carrier geometry does not belong to this component. The reduced snap and
receiver must first be mechanically coherent as a pair; only then should a
consumer decide what the snap carries.

# Reduced detachable receiver — design

<!-- scad-render-defaults
engine: openscad
source: interface_receiver_render.scad
module: interface_receiver_design
vpr: [68, 0, 28]
-->

## Purpose

This is the **primary fixed-side experiment object**. Rail and plate are not
the receiver design; they are later examples of integrating this receiver into
a carrier.

The standalone block is:

```text
width                    10 mm
height                    4 mm
total block length       14 mm

central functional zone  10 mm
top-guide extension       2 mm each end
```

The 14 mm block gives the receiver-top guide real material in which to return to
the ordinary outside profile.

<!-- scad-render
view: final
-->

## Source-derived X/Z mating profile

The fixed-side X/Z profile is radially mirrored from the pinned OpenGrid Lite
receiver:

```text
Z 0.0 .. 1.6     width 8.6 mm
Z 1.6 .. 2.6     8.6 -> 10.0 mm
Z 2.6 .. 3.6     width 10.0 mm
Z 3.6 .. 4.0     10.0 -> 9.2 mm
```

The lower mating region remains 8 mm active with 1 mm transition on each end
inside the 10 mm functional zone.

## Top insertion guide

The top 0.4 mm has a different job: insertion guidance.

The complete main X/Z lead-in remains present from Y=-5 to Y=+5. A further
2 mm at each end returns that guide into the untouched top corner, giving a
14 mm total top-guide envelope.

The acceptance requirement is geometric rather than cosmetic:

> the 10 mm main sloped face must remain complete, and its Y ends must transition
> through a sloped surface rather than a vertical end wall.

This top/end transition is still under active visual review in PR #4.

## Millimetre reference grooves

The optional 1 mm reference cross is a shallow non-functional groove. It may run
to the real part boundary; intersection with the receiver outline clips it.

<!-- scad-render
view: plain
-->

The plain view exists to judge the functional geometry without the reference
grooves.

## Integration boundary

The reusable design object ends here. A rail, plate, HUB75 coupler or other
consumer chooses how this 10 × 14 × 4 mm receiver region is embedded into its
own structure.

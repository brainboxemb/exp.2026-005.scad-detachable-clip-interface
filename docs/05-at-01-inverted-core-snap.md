# AT-01 — inside-out Lite receiver concepts

Status: **active in PR #4**

## Purpose

AT-01 no longer treats the fixed part as a small isolated "core". The fixed
part is a **receiver** that must make sense as something a real coupler can own.

We test two carrier directions while keeping one local snap interface unchanged.

## Carrier A — receiver rail

The receiver itself forms a 50 mm rail:

```text
length          50 mm
max width       10 mm
height           4 mm
```

The removable snap is only 10 mm long and is open at both Y ends. It therefore
clips locally over the rail from above and can be positioned anywhere along the
50 mm length.

## Carrier B — receiver on plate

The exact same 50 mm receiver profile is placed on a wider base:

```text
plate length    50 mm
plate width     20 mm
plate height     6 mm
receiver        same 50 mm profile on top
```

This represents the alternative where the eventual coupler or mounting piece has
enough area for a broader fixed base.

The removable snap is identical between A and B.

## OpenGrid Lite derivation

Source:

```text
AndyLevesque/QuackWorks
e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
```

For the Lite receiver, QuackWorks takes the upper 4.0 mm of the Full 6.8 mm
receiver. The relevant opening width over that Lite height is:

```text
local Lite Z     opening width
0.0 .. 1.6       26.4 mm
1.6 .. 2.6       26.4 -> 25.0 mm
2.6 .. 3.6       25.0 mm
3.6 .. 4.0       25.0 -> 25.8 mm
```

AT-01 radially mirrors that opening around a constant chosen so the narrow
25.0 mm capture becomes a maximum 10.0 mm fixed receiver:

```text
AT-01 Z          fixed receiver width
0.0 .. 1.6        8.6 mm
1.6 .. 2.6        8.6 -> 10.0 mm
2.6 .. 3.6       10.0 mm
3.6 .. 4.0       10.0 -> 9.2 mm
```

This is the fixed receiver's X/Z profile for both carriers.

## Snap clearance and retention

The same radial mirror is applied to the normal Lite snap widths:

```text
OpenGrid snap body    24.8 mm
OpenGrid snap+nub     25.6 mm

AT-01 snap opening    10.2 mm
AT-01 nub opening      9.4 mm
AT-01 inward nub       0.4 mm per side
```

That preserves the original relationship:

- nominal body clearance: 0.1 mm per side at the 10.0 mm capture width;
- temporary nub interference: up to 0.3 mm per side while clicking over the
  capture band;
- seated nub/profile geometry relaxes into the lower mirrored receiver slope.

The original Lite snap is 3.4 mm high. Existing OpenGrid snap-mount usage places
a functional base on the snap top, supporting the top-flush relationship where
the 3.4 mm snap starts 0.6 mm above the 4.0 mm receiver bottom.

AT-01 therefore seats the removable snap at Z=0.6 relative to the local receiver
base.

## Two-sided retention

OpenGrid's normal snap retains on four sides. AT-01 intentionally keeps only the
two long +/-X receiver sides.

Reasons:

- a 10 mm-wide clip would become unnecessarily stiff with four active walls;
- the receiver is a continuous rail along Y, so Y-end retention is not needed;
- an open-ended snap can be installed anywhere along the rail from above;
- it isolates the question we care about: can two source-derived flex/retention
  walls hold a compact removable attachment?

The +/-X walls retain the OpenGrid-derived nub and click-slot relationships.
Along Y the snap remains open.

## Snap wall and flex slot

The previous `2.0 mm` wall value hid several different functions. The wall is
now described as a radial stack:

```text
inside / nub side

0.7 mm  flex tongue       source-derived
0.6 mm  click slot        source-derived
0.7 mm  outer support     experiment-owned
----------------------
2.0 mm  total wall

outside
```

The first two values come directly from the normal OpenGrid snap geometry. Its
24.8 mm body has an outer face at 12.4 mm from centre. The 0.6 mm click slot is
centred 1.0 mm inward at 11.4 mm, leaving:

```text
12.4 - (11.4 + 0.6 / 2) = 0.7 mm
```

for the nub-bearing flex tongue.

The main click slot also keeps the upstream **0.3 mm rounding**. This is not an
AT-01 substitute radius. The upper 1.4 × 12 × 0.4 mm wall slot is rectangular
in QuackWorks and remains rectangular here.

The outer 0.7 mm support is not source-derived. It is the first printable coupon
choice and should be varied separately later rather than being confused with
the flex-tongue thickness.

## Other experiment-owned dimensions

```text
snap length along receiver  10.0 mm
outer support                 0.7 mm
snap top thickness            1.2 mm
```

The source-derived mating/flex dimensions remain separate constants in the
model.

## Evidence

PNG:

- rail assembled;
- rail exploded;
- rail retention section;
- plate assembled;
- plate exploded;
- plate retention section;
- rail-versus-plate comparison;
- receiver rail alone;
- receiver plate alone;
- removable snap alone.

STL:

- receiver rail;
- receiver plate;
- removable snap;
- receiver rail profile slice;
- receiver plate profile slice;
- snap retention profile slice.

## Digital checks

Before accepting AT-01:

- rail receiver length is exactly 50 mm;
- rail receiver envelope is at most 10 mm wide and exactly 4 mm high;
- plate base is exactly 50 × 20 × 6 mm;
- plate variant uses the same receiver profile as the rail variant;
- one identical snap is used in both assemblies;
- seated snap bottom is 0.6 mm above each local receiver base;
- snap top-stop underside coincides with receiver Z=4.0 mm;
- no static solid overlap exists in the seated section;
- complete and profile STLs are manifold;
- renders are inspected rather than accepted from CI status alone.

## Physical boundary

CAD can establish the intended profile and assembled relation. It cannot yet
accept insertion force, removal force, fatigue, best material or final wall
thickness. Those require printed coupons after the geometry is digitally
coherent.

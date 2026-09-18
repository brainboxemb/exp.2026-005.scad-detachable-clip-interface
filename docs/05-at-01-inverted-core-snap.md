# AT-01 — inside-out Lite receiver concepts

Status: **active in PR #4**

## Purpose

AT-01 no longer treats the fixed part as a small isolated "core". The fixed
part is a **receiver** that must make sense as something a real coupler can own.

We test two carrier directions while keeping one local snap interface unchanged.

## Carrier A — receiver rail

The carrier is a 50 × 10 × 4 mm rail, but the receiver interface exists at
**one local 10 × 10 mm position only** in the middle:

```text
carrier length              50 mm
carrier width               10 mm
carrier height               4 mm
receiver footprint          10 × 10 mm
receiver active length       6 mm
transition to carrier        2 mm each end
```

Outside that 10 mm receiver footprint the rail remains an ordinary rectangular
10 × 4 mm section. The removable snap clips only at the defined local receiver
position; it is not a free-sliding rail attachment.

## Carrier B — receiver on plate

The same local 10 × 10 mm receiver is placed on a wider base:

```text
plate length    50 mm
plate width     20 mm
plate height     6 mm
receiver        one local 10 × 10 mm position on top
```

This represents the alternative where the eventual coupler or mounting piece has
enough area for a broader fixed base.

The removable snap and the local receiver mating profile are identical between
A and B. Only the surrounding carrier differs.

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

This is the fixed receiver's X/Z profile inside the local 10 × 10 mm receiver
footprint for both carriers. Along Y, an 8 mm active region uses this profile
and 1 mm transitions at each end return into the surrounding carrier.

## Receiver lead-out geometry

The local receiver must not end as a hard vertical profile change.

Across the 10 mm footprint, both carrier concepts therefore use:

```text
Y = -5 .. -3 mm    sloped transition into receiver
Y = -3 .. +3 mm    full source-derived receiver profile
Y = +3 .. +5 mm    sloped transition back to carrier
```

The transition is a linear loft between corresponding carrier and receiver
cross-sections. Extending the lead-in/lead-out from 1 mm to 2 mm makes the
profile visibly gradual, similar to the way the OpenGrid geometry blends a local
functional cell into its surrounding material.

For the rail the slope returns to the normal 10 × 4 mm rail section. For the
plate the receiver ridge slopes back into the plate top.

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
- the local receiver is intentionally only 10 mm long, so Y-end retention is
  not needed;
- an open-ended snap installs vertically onto that one local receiver position;
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

- rail carrier envelope is exactly 50 × 10 × 4 mm;
- only the middle 10 mm of the rail contains receiver profiling;
- the local receiver has a 6 mm active region plus two 2 mm sloped transitions;
- plate base is exactly 50 × 20 × 6 mm;
- only one local 10 × 10 mm receiver exists on the plate;
- plate variant uses the same local receiver profile as the rail variant;
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

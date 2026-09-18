# AT-01 — inverted 10 mm fixed-core snap

Status: **active in PR #4**

## Purpose

AT-01 is the first experiment-owned detachable interface.

It deliberately inverts the relationship studied in OpenGrid:

```text
OpenGrid reference            AT-01

fixed receiver outside        fixed compact core inside
removable snap inside         removable shell outside
```

No QuackWorks snap geometry is copied or scaled.

## Baseline dimensions

```text
fixed core envelope       10.00 × 10.00 × 4.00 mm
root shoulder                         0.60 mm
shell engagement                      3.40 mm
side clearance              0.20 mm per side
shell inside               10.40 × 10.40 mm
shell wall                           1.20 mm
shell outside              12.80 × 12.80 mm
shell top                            1.20 mm
fixed groove depth                    0.40 mm
shell nub protrusion                  0.35 mm
temporary flex interference           0.15 mm
```

The 0.6 + 3.4 = 4.0 relationship is now an explicit AT-01 design choice. It is
not claimed as an authoritative QuackWorks assembled offset.

## Mechanical decomposition

### Fixed side

The fixed feature is a rigid 10 × 10 × 4 mm square core.

Two shallow retention grooves are cut inward into the opposite X faces. The
entire fixed feature therefore remains inside an exact 10 × 10 × 4 mm envelope.

The fixed side contains no protruding snap geometry and no intended flexure.

### Removable side

The removable part is a square shell.

Its nominal 10.40 mm internal opening gives 0.20 mm locating clearance per side
around the 10 mm core.

Two opposite X walls contain a central compliant tongue. Relief slots from the
open bottom isolate each tongue so it can flex outward.

Each tongue carries a nub that protrudes **inward** into the shell cavity. During
insertion that nub rides over the fixed core; when seated it falls into the
matching inward groove in the fixed core.

The Y walls carry no retention feature and primarily locate the shell.

### Assembly direction

The shell approaches from +Z and falls around the fixed core.

When seated:

- shell skirt bottom is at Z=0.6 mm;
- engagement runs from Z=0.6 to Z=4.0 mm;
- shell top plate underside meets the fixed-core top at Z=4.0 mm;
- the lower 0.6 mm of fixed core remains exposed as a root/attachment shoulder.

## Retention concept

The retention geometry now follows the intended inverted architecture:

```text
fixed core:       groove inward
removable shell:  nub inward
```

The shell inner face has 0.20 mm nominal clearance from the fixed core. The
retention nub protrudes 0.35 mm inward from that inner face, so while it passes
the unrecessed core face the compliant tongue needs approximately:

```text
0.35 - 0.20 = 0.15 mm
```

outward deflection.

The nub's lower surface is a lead-in ramp for downward insertion. Its upper
return is steeper so upward removal sees a stronger retention edge.

The fixed groove is 0.40 mm deep, which is deeper than the 0.15 mm interference.
At the final seated position the nub aligns with that groove and the tongue can
relax.

The groove/nub seated Z interval is 1.35..2.15 mm in fixed-core coordinates.

This is a CAD hypothesis only. Actual insertion/pull-out force requires printed
coupons.

## Why two-sided retention first

Four-sided retention would make a 10 mm shell unnecessarily stiff and would mix
locating and flexure on every wall.

AT-01 instead separates functions:

```text
X walls   locate + flex + retain
Y walls   locate
top plate axial stop
fixed core rigid load path
```

A later experiment can add more retention sides only if two-sided retention
proves insufficient.

## Digital acceptance checks

AT-01 must verify:

- complete fixed-core envelope = exactly 10 × 10 × 4 mm including grooves;
- no fixed retention feature protrudes outside that envelope;
- shell inner opening = 10.40 × 10.40 mm;
- shell outer footprint = 12.80 × 12.80 mm;
- shell local height = 4.60 mm;
- assembled shell base = Z 0.60 mm;
- assembled shell underside/top stop = Z 4.00 mm;
- seated shell nubs align with the inward fixed-core grooves without static
  solid overlap;
- required nominal tongue deflection while passing the solid core face is
  0.15 mm;
- complete and profile STLs are manifold;
- rendered sections actually pass through the intended retention and locating
  planes.

## Evidence targets

PNG:

- AT-01 assembled;
- exploded;
- retention-side X-Z section;
- locating-side Y-Z section;
- fixed core;
- removable shell.

STL:

- fixed core;
- removable shell;
- fixed retention profile;
- shell retention profile;
- fixed locating profile;
- shell locating profile.

## Physical boundary

Digital evidence can establish geometry and intended flex direction. It cannot
accept:

- insertion force;
- pull-out force;
- fatigue;
- best material;
- best clearance;
- best rib protrusion.

Those become physical/tolerance questions after the basic AT-01 geometry is
digitally coherent.

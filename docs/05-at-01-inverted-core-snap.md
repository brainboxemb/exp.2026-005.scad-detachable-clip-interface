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
fixed core body           10.00 × 10.00 × 4.00 mm
root shoulder                         0.60 mm
shell engagement                      3.40 mm
side clearance              0.20 mm per side
shell inside               10.40 × 10.40 mm
shell wall                           1.20 mm
shell outside              12.80 × 12.80 mm
shell top                            1.20 mm
retention rib protrusion             0.35 mm
shell/rib flex interference           0.15 mm
retention lower lip                   0.60 mm
```

The 0.6 + 3.4 = 4.0 relationship is now an explicit AT-01 design choice. It is
not claimed as an authoritative QuackWorks assembled offset.

## Mechanical decomposition

### Fixed side

The fixed feature is a rigid 10 × 10 × 4 mm square core.

Two shallow retention ribs are added on opposite X sides. The nominal core body
remains 10 × 10 mm; the ribs locally increase the overall X envelope to
10.70 mm.

The fixed side contains no intended flexure.

### Removable side

The removable part is a square shell.

Its nominal 10.40 mm internal opening gives 0.20 mm locating clearance per side
around the 10 mm core.

Two opposite X walls contain a central compliant tongue. Relief slots at both
tongue edges let that wall flex outward. A through-window receives the fixed
retention rib when seated.

The Y walls have no snap windows and primarily locate the shell.

### Assembly direction

The shell approaches from +Z and falls around the fixed core.

When seated:

- shell skirt bottom is at Z=0.6 mm;
- engagement runs from Z=0.6 to Z=4.0 mm;
- shell top plate underside meets the fixed-core top at Z=4.0 mm;
- the lower 0.6 mm of fixed core remains exposed as a root/attachment shoulder.

## Retention concept

The fixed ribs are asymmetric in Z:

- a longer upper ramp is intended to spread the compliant tongue during
  insertion;
- a shorter lower ramp gives a more abrupt retention edge during removal.

The shell keeps a 0.60 mm-high solid lip below each retention window. This is
deliberate: the earlier 0.05 mm lip was both practically unprintable and allowed
the rib to enter the window with almost no flex event.

In the corrected geometry the nominal shell inner face is 0.20 mm outside the
10 mm core while the rib protrudes 0.35 mm. The retention tongue therefore needs
approximately 0.15 mm outward deflection while the lower lip passes the rib.

At the final seated position the rib is fully inside the window, allowing the
tongue to relax again.

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

- core body = exactly 10 × 10 × 4 mm before ribs;
- overall ribbed fixed envelope = 10.70 × 10 × 4 mm;
- shell inner opening = 10.40 × 10.40 mm;
- shell outer footprint = 12.80 × 12.80 mm;
- shell local height = 4.60 mm;
- assembled shell base = Z 0.60 mm;
- assembled shell underside/top stop = Z 4.00 mm;
- final retention ribs occupy their windows without static solid overlap;
- lower retention lip is 0.60 mm, not a sub-layer-thickness artifact;
- required nominal tongue deflection at the rib is 0.15 mm;
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

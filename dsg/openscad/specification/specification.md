# Detachable interface specification

Status: **PoP baseline for transverse mating geometry; longitudinal receiver termination under review**

This document is the **stage-1 contract** between the fixed and removable
parts. It defines the mating relationship before choosing carrier geometry or a
production part.

The current nominal baseline is a **10 mm wide × 4 mm high** fixed-side
interface. The shared contract is the OpenGrid-derived X/Z mating profile and
its mirrored spacing. Longitudinal coupon length is a reference-implementation
choice, not an additional profile definition. Parameters are exposed through
functions so later experiments can study other sizes, but only the 10 × 4 mm
baseline is currently part of the PoP.

`interface_specification.scad` and
`../lib/detachable_interface_spec.scad` are the specification sources. The
node receiver/snap are **stage-2 reference implementations** of this contract.

<!-- scad-render-defaults
engine: openscad
source: specification/interface_specification.scad
module: interface_specification_design
-->

## OpenGrid Lite fixed-side profile

The drawing producer reconstructs the horizontal edge planes at Lite-local
Z=1.6, 2.6, 3.6 and 4.0 mm. Python derives them from source millimetre
relationships; OpenSCAD cuts the actual pinned 3D model at the same heights as
an independent oracle.

Lower segments hidden by higher material are removed before publishing the
top-view edge set. Raw section vertices and final visible-edge endpoints are
checked with a 0.001 mm tolerance.

![OpenGrid top-view reconstruction](../../../../drawing/00-opengrid-python.png)

[Canonical Python SVG](../../../../drawing/00-opengrid-python.svg)

The same source analysis qualifies the stage-2 10 mm crop:

```text
minimum straight half-span   6.923045 mm
crop half-length             5.000000 mm
margin per end               1.923045 mm
```

![OpenGrid straight crop proof](../../../../drawing/03-opengrid-straight-crop-proof.png)

[Canonical crop-proof SVG](../../../../drawing/03-opengrid-straight-crop-proof.svg)

These are experiment-owned source interpretations, not upstream OpenGrid
manufacturing drawings.

## Node fixed tongue profile

The node translation has an established transverse X/Z profile. The stage-2
reference implementation also has an explicit finite construction: a centred
10 mm crop from the source straight-edge region.

That finite length is deliberately **not normative contract geometry**. The
transverse profile defines the shared mating relation; the 10 mm plan length is
one accepted reference implementation of it.

<!-- scad-render
engine: openscad
source: specification/mating_profiles.scad
module: mating_profile_design
view: node
format: svg
image: 01-node-fixed-tongue-profile-a4.svg
-->

The pinned OpenGrid source uses `path_extrude2d()` for straight edges and
constructs corners separately from `full_tile_corners_profile`. The validated
sections show that a centred 10 mm crop ends 1.923045 mm before those corner
regions begin in the limiting Lite section, so the node can use a finite
straight-edge crop without inventing a corner translation.

## Overview

The first picture shows only the two minimal reference parts, separated so the
fixed/removable roles are obvious. It is an implementation illustration, not
the normative definition of the interface.

<!-- scad-render
view: overview
image: 00-reference-implementation-overview.png
vpr: [70, 0, 30]
size: [1200, 700]
-->

## Symmetric reference-pair context

The complete symmetric section below is retained only as context for the
reference pair. It is **not** the primary interface definition; the primary
contract is the local mating profile and mirrored spacing defined above.

<!-- scad-render
view: reference-pair-section
format: svg
image: 10-reference-pair-section.svg
-->

Nominal mating dimensions:

| Contract item | Baseline |
| --- | ---: |
| fixed-side capture spacing | 10.0 mm |
| fixed-side envelope height | 4.0 mm |
| receiver lower width | 8.6 mm |
| receiver top width | 9.2 mm |
| removable-side inner width | 10.2 mm |
| removable-side nub opening | 9.4 mm |
| nub protrusion | 0.4 mm per side |
| removable engagement height | 3.4 mm |
| seated Z offset | 0.0 mm |

The 0.6 mm difference between the 4.0 mm fixed-side envelope and 3.4 mm
engagement height is an envelope difference only. It is **not** converted into
a seated offset.

The retained fixed-side Z breakpoints are:

```text
0.0 -> 1.6 -> 2.6 -> 3.6 -> 4.0 mm
```

## OpenGrid source interpretation and our translation

The next sheet exists specifically to make the derivation visible.

The left profile is an **experiment interpretation** reconstructed from the
pinned QuackWorks/OpenGrid Lite dimensions. It is **not an upstream OpenGrid
manufacturing drawing**. The right profile is our reduced contract.

<!-- scad-render
view: opengrid-translation
format: svg
image: 11-width-reduction-context.svg
-->

The radial relation used by this PoP is:

```text
OpenGrid capture 25.0 -> interface capture 10.0
OpenGrid lower   26.4 -> receiver lower     8.6
OpenGrid top     25.8 -> receiver top       9.2
OpenGrid body    24.8 -> snap inner        10.2
OpenGrid nub     25.6 -> nub opening        9.4
```

The Z profile bands remain at the pinned Lite positions. The transformation is
therefore not a uniform scale of the OpenGrid object.

Pinned source:

```text
fork:   brainboxemb/fork.andylevesque.quackworks
commit: e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
files:  openGrid/openGrid.scad
        openGrid/opengrid-snap.scad
```

## Stage 2 — minimal reference implementation

A contract is useful only if a minimal pair can implement it. The PoP therefore
keeps one **minimal receiver** and one **minimal snap** as the stage-2 reference
implementation.

<!-- scad-render
view: reference-implementation
format: svg
image: 12-reference-implementation.svg
-->

The minimal pair uses a 10 mm straight reference length. For the receiver this
is a validated centred crop from the source straight edge, not a scaled source
corner. That length,
carrier material outside it, mounting geometry and any larger production-part
envelope remain reference-implementation/integration choices.

Detailed implementation documents:

- [Minimal receiver](../components/node-receiver/node_receiver/design/design.md)
- [Minimal snap](../components/node-snap/node_snap/design/design.md)

The implementation documents may explain flex slots, top support, print
reference grooves and construction steps. Those details do not become
interface requirements unless they are promoted into this specification.

## Qualification boundary

This specification defines digital geometry only. It does not yet establish
insertion force, removal force, fatigue life, material choice, printer
tolerance robustness or load capacity. Those remain physical qualification
questions.

# Detachable interface specification

Status: **PoP baseline**

This document is the **stage-1 contract** between the fixed and removable
parts. It defines the mating relationship before choosing carrier geometry or a
production part.

The current nominal baseline is a **10 mm wide × 4 mm high** fixed-side
interface. The contract code exposes width/height through functions so later
experiments can study other sizes, but only the 10 × 4 mm baseline is currently
part of this PoP.

`interface_specification.scad` and
`../lib/detachable_interface_spec.scad` are the specification sources. The
node receiver/snap are **stage-2 reference implementations** of this contract.

<!-- scad-render-defaults
engine: openscad
source: specification/interface_specification.scad
module: interface_specification_design
-->

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

## Interface contract

The dimensioned section below is the primary interface drawing. The receiver
contract boundary and minimal snap section are shown together so clearance and
retention are visible in one view.

<!-- scad-render
view: interface-contract
format: svg
image: 01-interface-contract.svg
-->

Nominal mating dimensions:

| Contract item | Baseline |
| --- | ---: |
| fixed-side capture width | 10.0 mm |
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
image: 02-opengrid-to-interface-translation.svg
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
image: 03-reference-implementation.svg
-->

The 10 mm Y length used by these coupons is a reference-implementation choice;
it is not a required production carrier length.

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

# Detachable interface specification

Status: **PoP baseline**

This document is the **stage-1 contract** between the fixed and removable
parts. It defines the mating relationship before choosing carrier geometry or a
production part.

The current nominal baseline is a **10 × 10 × 4 mm local fixed-side mating
patch**: 10 mm mirrored spacing, 10 mm longitudinal extent and 4 mm height.
The contract is three-dimensional; neither the transverse section nor the plan
shape alone is sufficient. Parameters are exposed through functions so later
experiments can study other sizes, but only this baseline is currently part of
the PoP.

`interface_specification.scad` and
`../lib/detachable_interface_spec.scad` are the specification sources. The
node receiver/snap are **stage-2 reference implementations** of this contract.

<!-- scad-render-defaults
engine: openscad
source: specification/interface_specification.scad
module: interface_specification_design
-->

## OpenGrid Lite fixed-side profile

The interface is not a single X/Z profile. A useful definition needs both the
transverse section and the way that feature runs and terminates along its path.

The first A4 sheet therefore uses the exact pinned OpenGrid Lite receiver
geometry in two orthogonal views:

- plan: the straight edge plus its corner/termination behaviour;
- A-A: the transverse X/Z section.

<!-- scad-render
engine: openscad
source: specification/mating_profiles.scad
module: mating_profile_design
view: opengrid
format: svg
image: 00-opengrid-fixed-profile-a4.svg
-->

This is an experiment-owned drawing of the pinned QuackWorks model, not an
upstream OpenGrid manufacturing drawing.

## Node fixed tongue profile

The node translation is a compact local tongue. Its complete current baseline
is:

```text
overall longitudinal length     10.0 mm
full-depth active length         8.0 mm
end depth blend                  1.0 mm each end
fixed-side envelope height       4.0 mm
nominal mirrored spacing        10.0 mm
```

The second A4 sheet again shows both required descriptions: the plan definition
of the complete tongue and A-A through the active center.

<!-- scad-render
engine: openscad
source: specification/mating_profiles.scad
module: mating_profile_design
view: node
format: svg
image: 01-node-fixed-tongue-profile-a4.svg
-->

The 1 mm end region returns only the radial cut depth to zero. The top plane
stays at Z=4 mm. The current PoP uses a smooth depth blend:

```text
depth(t) = 1 - (3 t^2 - 2 t^3),  t = 0..1
```

The sampled section count is only a mesh/tessellation choice and is not part of
the interface dimensioning.

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
contract is one local mating side as drawn above.

<!-- scad-render
view: reference-pair-section
format: svg
image: 10-reference-pair-section.svg
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

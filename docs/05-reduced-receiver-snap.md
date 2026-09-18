# Reduced detachable receiver + snap

Status: **active in PR #4**

## Purpose

This phase answers one focused question:

> Can the pinned OpenGrid Lite receiver/snap relationship be reduced to a
> compact two-sided detachable interface that is useful outside OpenGrid?

The experiment now separates **design objects** from **carrier examples**.

## Authority map

The component-local design documents are authoritative for geometry:

| Object | Role | Design document |
| --- | --- | --- |
| OpenGrid Lite receiver | pinned upstream fixed-side reference | `dsg/openscad/components/opengrid-lite-receiver/design/design.md` |
| OpenGrid Lite snap | pinned upstream removable-side reference | `dsg/openscad/components/opengrid-lite-snap/design/design.md` |
| Node receiver | experiment-owned fixed-side design | `dsg/openscad/components/node-receiver/design/design.md` |
| Node snap | experiment-owned removable-side design | `dsg/openscad/components/node-snap/design/design.md` |

This file records the **experiment relationship and acceptance boundary**. It
must not duplicate every component dimension; those details belong in the
component design documents.

## Carrier examples

Carrier integrations are deliberately one step beyond the base interface:

```text
dsg/openscad/examples/receiver-rail/
dsg/openscad/examples/receiver-plate/
```

They demonstrate two contexts:

```text
rail   50 × 10 × 4 mm
plate  50 × 20 × 6 mm + receiver block
```

Neither carrier is the definition of the receiver.

## Pinned source

```text
upstream: AndyLevesque/QuackWorks
fork:     brainboxemb/fork.andylevesque.quackworks
commit:   e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
```

Relevant upstream files:

```text
openGrid/openGrid.scad
openGrid/opengrid-snap.scad
```

The source/provenance and CC BY-NC-SA 4.0 boundary are documented in
`docs/00-source-provenance.md`.

## Reduction principle

The experiment retains the functional roles before varying them:

```text
OpenGrid Lite receiver profile
        ↓ radial mirror / local reduction
reduced fixed receiver

OpenGrid normal Lite snap
        ↓ inward nub + two retained flex walls
reduced removable snap
```

The reduced interface intentionally uses only +/-X retention. The Y ends remain
open.

## Current receiver design question

The receiver is now a standalone 10 × 10 × 4 mm object.

Its lower source-derived mating profile occupies the same 10 mm footprint.
The upper insertion guide is treated separately: the full X/Z guide remains
over the central 6 mm, with a 2 mm transition at each end that returns to the
ordinary receiver width inside the same 10 mm footprint.

Current visual acceptance criterion:

- the full top guide remains 6 mm long in the centre;
- each 2 mm end transition stays inside the 10 mm receiver footprint;
- the full-guide region must not terminate in a vertical end wall;
- the end transition must visibly slope back into the ordinary receiver block;
- left/right and front/back geometry must remain symmetric.

The exact construction belongs in the reduced receiver design document.

## Current snap design question

The reduced snap is its own design object rather than a feature of either
carrier example.

Current retained decisions:

- 10 mm length;
- two active +/-X flex/retention walls;
- shaped OpenGrid-derived inward nub rather than the superseded straight
  trapezoid;
- straight flex slot remains a compliance feature;
- clipped-corner plan form is retained;
- top/core outer chamfer is currently unified;
- optional 1 mm physical reference grooves may run to the real part boundary.

The snap's final force, fatigue and tolerance behaviour remain unqualified until
printed coupons exist.

## Generated output order

Primary geometry appears first:

```text
01-opengrid-lite-receiver
02-opengrid-lite-snap
03-node-receiver
04-node-snap
```

Carrier examples follow:

```text
10-example-receiver-rail
11-example-receiver-plate
12-example-rail-assembled
13-example-plate-assembled
```

The reference work and active design phase are named directly after the
geometry being evaluated; internal testcase-style phase codes are not used.

## Acceptance boundary

The reduced receiver + snap phase is not complete merely because CI is green.

Before acceptance:

1. component design documents and production geometry must agree;
2. generated receiver/snap renders must be visually reviewed;
3. STL output must remain manifold;
4. neutral receiver/snap coupons must be printed;
5. insertion/removal behaviour and flex survival must be observed;
6. only then should tolerance variants or production-carrier integration be
   treated as the next experiment question.

Rail/plate examples must not be used to hide an unresolved base receiver/snap
geometry problem.

# Reduced detachable receiver + snap

Status: **active in PR #7**

## Purpose

This phase answers one focused question:

> Can the pinned OpenGrid Lite receiver/snap relationship be reduced to a
> compact two-sided detachable interface that is useful outside OpenGrid?

The experiment now separates **design objects** from **carrier examples**.

## Authority map

The component-local design documents are authoritative for geometry:

| Object | Role | Design document |
| --- | --- | --- |
| OpenGrid Lite receiver | pinned upstream fixed-side reference | `dsg/openscad/components/opengrid-lite-receiver/opengrid_lite_receiver/design/design.md` |
| OpenGrid Lite snap | pinned upstream removable-side reference | `dsg/openscad/components/opengrid-lite-snap/opengrid_lite_snap/design/design.md` |
| Node receiver | experiment-owned fixed-side design | `dsg/openscad/components/node-receiver/node_receiver/design/design.md` |
| Node snap | experiment-owned removable-side design | `dsg/openscad/components/node-snap/node_snap/design/design.md` |

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

## Geometry provenance snapshot

The PoP must not mix source dimensions and experiment choices without saying so.

### Receiver

| Item | OpenGrid Lite | Reduced node | Class |
| --- | ---: | ---: | --- |
| receiver height | 4.0 mm | 4.0 mm | upstream retained |
| capture width | 25.0 mm | 10.0 mm | experiment target |
| lower width | 26.4 mm | 8.6 mm | derived radial mirror |
| top width | 25.8 mm | 9.2 mm | derived radial mirror |
| Z profile bands | 0/1.6/2.6/3.6/4.0 mm | same | upstream retained |
| straight-edge/path length | tile edge | 10.0 mm | experiment choice |
| Y profile variation | none on straight edge | none | construction principle retained |

### Snap

| Item | OpenGrid normal Lite snap | Reduced node snap | Class |
| --- | ---: | ---: | --- |
| body width | 24.8 mm | 10.2 mm inner width | derived radial mirror |
| nub radial depth | 0.4 mm | 0.4 mm | upstream retained |
| nub tangential width | 11.0 mm | 4.4 mm | derived ×0.4 |
| nub base height | 0.2 mm | 0.2 mm | upstream retained |
| upper/lower wedge | 0.6 / 0.6 mm | same | upstream retained |
| rounding radius / Y scale | 13.025 / 1.36 | same radial construction | upstream retained |
| click-slot width | 0.6 mm | 0.6 mm | upstream retained |
| click-slot length | 12.4 mm | 4.96 mm | derived ×0.4 |
| flex tongue | 0.7 mm | 0.7 mm | derived from source slot/body geometry |
| outer support beyond slot | n/a | 0.7 mm | **experiment choice** |
| node top thickness | n/a | 1.2 mm | **experiment choice** |
| local snap length | no reduced local equivalent | 10.0 mm | **experiment choice** |

The old `0.6 mm` “seated offset” is **not** an upstream dimension. The pinned
reference assembles receiver and snap at the same CENTER anchor; the 0.6 mm is
only the arithmetic difference between 4.0 mm receiver height and 3.4 mm Lite
snap height.

The node assembly therefore now uses the same-origin reference as its default:
`NODE_SNAP_SEATED_Z = 0.0`. A non-zero node assembly offset would require
separate qualification evidence instead of being inferred from the height
difference.

## Current receiver design question

The receiver is a standalone 10 mm-long straight extrusion of one
OpenGrid-derived X/Z profile.

Its source-derived profile is:

```text
Z 0.0 .. 1.6     width 8.6 mm
Z 1.6 .. 2.6     ramp 8.6 -> 10.0 mm
Z 2.6 .. 3.6     width 10.0 mm
Z 3.6 .. 4.0     ramp 10.0 -> 9.2 mm
```

The construction now follows the upstream OpenGrid principle directly:
`polygon(profile) -> BOSL2 path_extrude2d(straight path)`. The complete X/Z
profile remains constant over the full 10 mm path.

There is no receiver-owned Y fade or 8+1 mm end treatment. If a future carrier
needs a transition between the local receiver and surrounding material, that is
an integration question and must be qualified separately.

Current visual acceptance criteria:

- all four X/Z zones are visible in an orthographic profile;
- the profile is constant over the complete 10 mm length;
- STL side faces are ordinary planar extrusion faces, not a fan of sampled hull
  facets;
- the top 3.6..4.0 mm chamfer is part of the same profile;
- left/right geometry remains symmetric.

The exact construction belongs in the node receiver design document.

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

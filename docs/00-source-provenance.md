# Source provenance

## Selected OpenGrid mechanism reference

The first PoP baseline uses:

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

The fork is a real GitHub fork of `AndyLevesque/QuackWorks`; its `main` was
verified at the exact commit above when this experiment was bootstrapped.

## Why QuackWorks is the primary reference

The architecture matches the question being investigated:

- the OpenGrid board/cell is the fixed receiver;
- `openGridSnap()` is a separate removable approximately 24.8 mm part;
- perimeter nubs provide retention;
- long click-hole regions provide local compliance;
- the directional mode demonstrates asymmetric retention without replacing the
  complete receiver architecture.

Other sources remain comparison/evidence references:

- `nnarain/opengrid-snap-mount-generator` — application example that attaches
  OpenGrid snaps to an arbitrary mounting plate;
- `dnnsmnstrr/connector-foundry` — wrapper plus reference-shape and assembled
  fit verification patterns;
- `jp-embedded/opengrid` — alternative snap/socket and lock mechanisms;
- `openGrid-3D/openGrid-openSCAD` — official OpenGrid ecosystem reference.

## Licensing/provenance boundary

QuackWorks declares CC BY-NC-SA 4.0 at repository level. The snap source also
contains additional attribution/licensing wording crediting the OpenGrid design
to David D and the OpenSCAD snap implementation to metasyntactic.

For this PoP:

- upstream code remains a pinned external dependency;
- OG-01 poses/renders/exports that upstream geometry without claiming ownership;
- experiment-owned geometry will be kept separate from upstream geometry;
- direct production reuse requires a deliberate licensing/provenance decision.

This is an engineering provenance record, not legal advice.


## AT-01 derived geometry

AT-01 intentionally derives its local mating profile from the pinned QuackWorks
OpenGrid Lite receiver and normal snap at:

```text
AndyLevesque/QuackWorks
e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
```

The engineering transformation is documented rather than disguised:

- the Lite receiver inner-wall X/Z profile is radially mirrored into a compact
  fixed receiver outer profile;
- the normal snap's outward 0.4 mm nubs become inward nubs on the removable
  snap;
- only two opposite retention sides are kept for the 10 mm-wide rail concept;
- outer wall/top thickness and carrier geometry are experiment-owned.

The QuackWorks repository declares CC BY-NC-SA 4.0 and the snap source separately
credits the OpenGrid Snap design by David D and OpenSCAD implementation by
metasyntactic. This experiment keeps that attribution and treats AT-01 as
derived geometry. Any later production integration must carry the applicable
upstream attribution/licence notice alongside the derived interface geometry.

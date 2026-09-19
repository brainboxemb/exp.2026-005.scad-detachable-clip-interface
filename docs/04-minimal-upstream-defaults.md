# Minimal upstream-default reference correction

Status: **complete in PR #3**

## Why this correction exists

The upstream Full reference and the Full/Lite comparison were intended to
describe the upstream QuackWorks geometry, but
their experiment wrappers overrode more parameters than necessary:

- tile size;
- full tile thickness;
- screw mounting;
- chamfers;
- connector holes;
- anchor;
- spin/orientation;
- explicit Full/Lite and directional selectors even when the upstream default
  already selected the desired case.

That makes it unnecessarily difficult to distinguish upstream behaviour from
experiment-owned posing.

## Minimal safe calls

The receiver modules require board dimensions but already provide defaults for
the remaining reference parameters:

```scad
openGrid(
    Board_Width=1,
    Board_Height=1
);

openGridLite(
    Board_Width=1,
    Board_Height=1
);
```

The snap signature lists `orient`, `anchor` and `spin` without explicit
defaults, but QuackWorks itself calls `openGridSnap()` with those arguments
omitted. The reference therefore follows that upstream usage directly.

Full:

```scad
openGridSnap();
```

Lite:

```scad
openGridSnap(lite=true);
```

No other snap parameter is overridden.

## Assembly correction

PR #3 removes the experiment-derived 0.6 mm Lite Z offset from the reference
assembly. Full and Lite are first posed on the same upstream CENTER anchor.

The 0.6 mm arithmetic height difference remains a useful observation, but it is
not treated as an authoritative seated relationship until the minimal-default
reference output supports that interpretation.

## Section correction

The previous section volumes assumed bottom-anchored geometry and clipped only a
positive Z range. The corrected section/profile volumes span both positive and
negative Z so changing back to upstream CENTER anchors cannot silently discard
half the profile.

## Acceptance

Compare the regenerated PR #3 PNG/STL output against the production upstream
Full reference and Full/Lite comparison
baseline and document every meaningful geometry/blob difference before replacing
the accepted reference findings.


## Cross-section interpretation

A central X-Z slice through the snap crosses the long side click-hole/flex slot.
That view is mechanically useful but visually misleading as a first overview:
intentionally missing flex-slot material can look like general clearance.

The experiment therefore keeps two corresponding profile planes for every
receiver/snap:

- `solid / beside flex slot` at Y=7 mm — primary overview;
- `center / flex slot` at Y=0 — technical spring/retention detail.

The solid plane is outside the 12.4 mm-long central side click-hole and shows the
continuous snap body. Both planes use the same 1.0 mm slice thickness. Generated
section PNGs now use the solid plane by default; separate `*-flex-section.png`
renders retain the center-plane evidence.

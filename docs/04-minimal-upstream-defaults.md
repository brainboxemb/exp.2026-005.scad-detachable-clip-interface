# Minimal upstream-default reference correction

Status: **active in PR #3**

## Why this correction exists

OG-01 and OG-02 were intended to describe the upstream QuackWorks geometry, but
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

The snap source is slightly different: `orient`, `anchor` and `spin` have
no defaults in the module signature, so those three placement arguments are
still technically required.

Full:

```scad
openGridSnap(
    orient=UP,
    anchor=CENTER,
    spin=0
);
```

Lite:

```scad
openGridSnap(
    lite=true,
    orient=UP,
    anchor=CENTER,
    spin=0
);
```

`directional` is intentionally left at its upstream default.

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

Compare the regenerated PR #3 PNG/STL output against the production OG-01/OG-02
baseline and document every meaningful geometry/blob difference before replacing
the accepted reference findings.

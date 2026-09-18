# OG-01 findings — upstream OpenGrid reference

Status: **accepted as the upstream reference baseline**

Source under test:

```text
brainboxemb/fork.andylevesque.quackworks
e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
```

Qualified by PR run:

```text
35336131546
```

Published PR Build provenance identifies the same exact experiment head and the
same QuackWorks gitlink.

## Generated evidence

PNG:

- `og-01-reference-assembled.png`
- `og-01-reference-exploded.png`
- `og-01-reference-section.png`

STL:

- `og-01-fixed-receiver.stl`
- `og-01-removable-snap.stl`

All five OpenSCAD targets report `Status: NoError`. Both STL targets report a
manifold top-level 3D object.

## What OG-01 establishes

The source geometry supports the following engineering description:

- the fixed side is an OpenGrid cell/receiver;
- the removable side is the separate `openGridSnap()`;
- the normal full snap is approximately 24.8 mm square;
- the full snap occupies the same nominal 6.8 mm Z envelope as the full board;
- the seated snap is placed inside the cell rather than on top of the board;
- retention is local around the snap perimeter;
- long side openings leave compliant material beside the retention features;
- locating, compliance and retention are therefore distinct functions even
  though they are integrated in one removable printed part.

The exploded render confirms the insertion relationship without receiver
occlusion. The section render exposes the receiver/snap mating region locally.

## What OG-01 does not establish

OG-01 does not prove:

- insertion force;
- pull-out force;
- fatigue or repeated-cycle behaviour;
- suitable material;
- tolerance robustness across printers;
- that the complete 24.8 mm square OpenGrid snap is the right size or shape for
  a HUB75 coupler;
- that upstream geometry should be copied into production.

Those are later PoP questions.

## Design consequence

The next useful step is **AT-01**, not a tube clip yet.

AT-01 should retain the functional decomposition visible in OG-01 while reducing
the complete OpenGrid cell context to a neutral attachment coupon:

```text
fixed receiver/contact geometry
        +
removable locating/compliant/retention geometry
```

The goal is to discover the minimum interface we actually need before adding the
horizontal tube-clamping function.

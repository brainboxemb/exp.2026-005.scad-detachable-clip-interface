# Upstream Full reference findings

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

- `50-reference-full-baseline-assembled.png`
- `51-reference-full-baseline-exploded.png`
- `52-reference-full-baseline-section.png`

STL:

- `50-reference-full-receiver.stl`
- `51-reference-full-snap.stl`

All five OpenSCAD targets report `Status: NoError`. Both STL targets report a
manifold top-level 3D object.

## What the upstream Full reference establishes

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

## What the upstream Full reference does not establish

the upstream Full reference does not prove:

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

The next useful step is the **reduced receiver + snap** phase, not a tube clip yet.

The reduced receiver + snap phase should retain the functional decomposition visible in the upstream Full reference while reducing
the complete OpenGrid cell context to a neutral attachment coupon:

```text
fixed receiver/contact geometry
        +
removable locating/compliant/retention geometry
```

The goal is to discover the minimum interface we actually need before adding the
horizontal tube-clamping function.

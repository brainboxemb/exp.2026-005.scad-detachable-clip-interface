# Experiment plan

## Question

Can a compact printed fixed-side interface accept a removable clip part with
repeatable insertion/removal and useful retention, while remaining printable,
serviceable and unobtrusive when no clip is installed?

The first intended product use is a separate aluminium-tube clip for the HUB75
display frame, but product integration is outside this PoP until the interface
has been qualified.

## Upstream Full reference assembly

**Status:** complete in PR #1.

**Findings:** [Upstream Full reference findings](02-upstream-full-reference-findings.md)

Goal: understand the selected source before adapting it.

Outputs:

```text
PNG
  assembled
  exploded
  section

STL
  fixed receiver
  removable snap
```

Questions:

- which solid is fixed and which is removable;
- what geometry locates the snap;
- where retention occurs;
- which regions flex;
- what is the seated Z relationship;
- what print orientation the upstream geometry assumes.

Exit: the exact upstream pair builds reproducibly and the generated evidence is
clear enough to describe the mechanism without guessing.

## Full versus Lite upstream comparison

**Status:** complete in PR #2.

**Findings:** [Full/Lite findings](03-upstream-full-lite-comparison-findings.md)

Goal: understand the upstream Lite interface before reducing OpenGrid to a
project-owned neutral coupon.

Upstream dimensions at the pinned QuackWorks revision:

```text
                    receiver     snap
Full                  6.8 mm     6.8 mm
Lite                  4.0 mm     3.4 mm
footprint                         ~24.8 x 24.8 mm
```

The Lite receiver is derived from the upper portion of the Full receiver. The
Lite snap likewise removes the lower Full-height stage. The accepted reference
keeps the upstream CENTER anchoring for both parts; the arithmetic 0.6 mm height
difference is not converted into a seated offset.

Evidence:

- Full/Lite assembled, exploded and section comparison PNGs;
- individual central X-Z profile PNGs for Full receiver, Full snap, Lite
  receiver and Lite snap;
- matching 1.0 mm-thick profile-slice STL exports for those four solids;
- complete Lite receiver and Lite snap STL exports;
- reuse the upstream Full reference receiver/snap STLs rather than duplicate them.

Questions:

- what material/height disappears in Lite;
- which locating and retention geometry remains;
- whether the footprint stays unchanged;
- whether Full and Lite preserve the same top functional surface;
- whether Lite is a better starting point for the compact fixed-side
  interface.

Directional retention is deliberately deferred.

Exit: generated evidence makes the Full/Lite difference explicit and the
findings select the better starting principle for the reduced interface without introducing
HUB75 geometry.

## Reference correction — minimize upstream overrides

**Status:** complete in PR #3.

Before reducing the interface, revalidate the upstream Full reference and Full/Lite comparison using the smallest safe upstream call
surface. See [minimal upstream-default correction](04-minimal-upstream-defaults.md).

The correction removes experiment-owned parameter overrides and the derived Lite
assembly Z offset until the regenerated evidence supports an assembly relation.

## Reduced receiver + snap — two carrier concepts

**Status:** active — receiver/snap geometry and generated evidence are under refinement.

**Design record:** [Reduced receiver + snap](05-reduced-receiver-snap.md)

Goal: preserve a recognisable OpenGrid-Lite-derived mating profile while
inverting the roles and comparing two ways to carry the fixed receiver.

Shared local interface:

- radial mirror of the Lite receiver side profile;
- maximum fixed receiver width 10.0 mm;
- Lite snap body/nub clearance/interference relationship mirrored around that
  profile;
- retention/flex on the two long +/-X sides only;
- snap open at both Y ends so it clips locally from above;
- one 10 mm-long removable snap works on both carriers.

Carrier A — **rail**:

```text
carrier            50 × 10 × 4 mm
receiver zone      one local 10 × 10 mm position
active profile     8 mm
transition         1 mm at each Y end
```

The remainder of the 50 mm carrier stays rectangular.

Carrier B — **plate**:

```text
base plate          50 × 20 × 6 mm
support boss        10 × 10 × 4 mm
receiver zone       full 10 mm support footprint
lower active profile 8 mm
lower transition     1 mm at each Y end
top full guide       6 mm
top transition       2 mm at each Y end
```

The exact same removable snap must fit both.

Evidence:

- rail assembled/exploded/retention/transition sections;
- plate assembled/exploded/retention/transition sections;
- side-by-side concept render;
- separate receiver-rail, receiver-plate and removable-snap STLs;
- shared retention profile slices.

Exit: both carriers expose the same local snap interface and the generated
evidence shows no static overlap in the seated state. Physical insertion and
pull-out force remain later print-test questions.

## Retention and flex geometry

**Status:** provisional.

Make the retention nubs, compliant regions, lead-ins and load-carrying contact
surfaces measurable and easy to inspect.

## Tolerance qualification

**Status:** provisional.

Vary only the dimensions identified by the retention/flex analysis to control insertion/retention. Do not
create a broad matrix of arbitrary variants.

Physical coupon prints become useful here because snap/flex behaviour cannot be
accepted from CAD alone.

## Tube-clip carrier

**Status:** provisional.

After the attachment pair is qualified, add the actual horizontal
aluminium-tube retention function to the removable side.

Keep the decomposition visible:

```text
fixed interface
    +
removable interface
    +
tube clamp
```

## Production gate

The PoP can produce a qualified interface contract. It does not freeze or modify
the HUB75 panel-facing coupler interface.

Production integration waits for both:

1. HUB75 core panel/coupler physical acceptance + interface freeze;
2. this PoP's detachable interface qualification.

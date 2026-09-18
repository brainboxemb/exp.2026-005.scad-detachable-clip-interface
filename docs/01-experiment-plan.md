# Experiment plan

## Question

Can a compact printed fixed-side interface accept a removable clip part with
repeatable insertion/removal and useful retention, while remaining printable,
serviceable and unobtrusive when no clip is installed?

The first intended product use is a separate aluminium-tube clip for the HUB75
display frame, but product integration is outside this PoP until the interface
has been qualified.

## OG-01 — upstream reference assembly

**Status:** complete in PR #1.

**Findings:** [OG-01 upstream reference findings](02-og-01-findings.md)

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

## OG-02 — Full versus Lite upstream comparison

**Status:** complete in PR #2.

**Findings:** [OG-02 Full/Lite findings](03-og-02-findings.md)

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
Lite snap likewise removes the lower half of the Full snap. For a top-flush
assembled comparison, the Lite snap is therefore posed 0.6 mm above the Lite
receiver bottom.

Evidence:

- Full/Lite assembled, exploded and section comparison PNGs;
- individual central X-Z profile PNGs for Full receiver, Full snap, Lite
  receiver and Lite snap;
- matching 1.0 mm-thick profile-slice STL exports for those four solids;
- complete Lite receiver and Lite snap STL exports;
- reuse OG-01's complete Full receiver/snap STLs rather than duplicate them.

Questions:

- what material/height disappears in Lite;
- which locating and retention geometry remains;
- whether the footprint stays unchanged;
- whether Full and Lite preserve the same top functional surface;
- whether Lite is a better starting point for AT-01's compact fixed-side
  interface.

Directional retention is deliberately deferred.

Exit: generated evidence makes the Full/Lite difference explicit and the
findings select the better starting principle for AT-01 without introducing
HUB75 geometry.

## Reference correction — minimize upstream overrides

**Status:** complete in PR #3.

Before AT-01, revalidate OG-01/OG-02 using the smallest safe upstream call
surface. See [minimal upstream-default correction](04-minimal-upstream-defaults.md).

The correction removes experiment-owned parameter overrides and the derived Lite
assembly Z offset until the regenerated evidence supports an assembly relation.

## AT-01 — inside-out Lite receiver, two carrier concepts

**Status:** active in PR #4 — digital rail/plate baseline green; physical fit pending.

**Design record:** [AT-01 receiver concepts](05-at-01-inverted-core-snap.md)

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
receiver length    50 mm
max width          10 mm
height              4 mm
```

The receiver profile itself is the 50 mm rail.

Carrier B — **plate**:

```text
base plate         50 × 20 × 6 mm
receiver ridge     same 50 mm Lite-derived profile on top
```

The exact same removable snap must fit both.

Evidence:

- rail assembled/exploded/section;
- plate assembled/exploded/section;
- side-by-side concept render;
- separate receiver-rail, receiver-plate and removable-snap STLs;
- shared retention profile slices.

Exit: both carriers expose the same local snap interface and the generated
evidence shows no static overlap in the seated state. Physical insertion and
pull-out force remain later print-test questions.

## AT-02 — retention/flex section

**Status:** provisional.

Make the retention nubs, compliant regions, lead-ins and load-carrying contact
surfaces measurable and easy to inspect.

## AT-03 — tolerance variants

**Status:** provisional.

Vary only the dimensions shown by AT-02 to control insertion/retention. Do not
create a broad matrix of arbitrary variants.

Physical coupon prints become useful here because snap/flex behaviour cannot be
accepted from CAD alone.

## TC-01 — tube-clip carrier

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

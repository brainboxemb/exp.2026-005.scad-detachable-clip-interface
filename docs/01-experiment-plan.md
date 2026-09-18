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

## AT-01 — neutral fixed/removable coupon

**Status:** next after PR #1 merges.

Goal: isolate the minimum useful attachment relationship from the complete
OpenGrid tile context without adding HUB75 geometry.

Generate the same assembled/exploded/section PNG evidence plus separate fixed
and removable STL coupons.

Exit: the reduced coupon preserves the mechanism being tested and makes the
fixed-side footprint/load path explicit.

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

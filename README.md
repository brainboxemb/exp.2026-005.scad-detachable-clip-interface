# Detachable SCAD clip interface PoP

Proof of Principle for a detachable, printable OpenSCAD attachment interface
inspired by OpenGrid.

The first production driver is the removable aluminium reinforcement-tube clip
for the HUB75 display frame, but this repository deliberately starts with
neutral reference/coupon geometry. Production HUB75 couplers remain owned by
`brainboxemb/2026-009-01.cad.HUB75-display-frame`.

## Current phase

**OG-01 — upstream OpenGrid reference assembly**

The first step reproduces the selected upstream fixed receiver + removable snap
without redesigning either part. It generates both visual and printable evidence:

PNG:

- `og-01-reference-assembled.png`
- `og-01-reference-exploded.png`
- `og-01-reference-section.png`

STL:

- `og-01-fixed-receiver.stl`
- `og-01-removable-snap.stl`

After merge, normal production output is published under:

- [Build](../../tree/prod/bld)
- [PNG gallery](../../blob/prod/bld/png/README.md)
- [STL output](../../tree/prod/bld/stl)

## External source

The experiment pins:

```text
fork:     brainboxemb/fork.andylevesque.quackworks
upstream: AndyLevesque/QuackWorks
commit:   e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
```

The fork is a retained external-source boundary. Experiment-owned adapters,
coupons, analysis and evidence belong here, not in the fork.

See [source provenance](docs/00-source-provenance.md).

## Experiment sequence

1. **OG-01** — reproduce and understand the upstream receiver + snap.
2. **AT-01** — reduce the relationship to a neutral fixed/removable coupon.
3. **AT-02** — expose retention/flex geometry and critical dimensions.
4. **AT-03** — compare only the critical tolerance variants.
5. **TC-01** — add the real horizontal tube-clamping function after the
   attachment principle is understood.

See [experiment plan](docs/01-experiment-plan.md).

## Build model

This is an OpenSCAD-only consumer of the current shared SCAD project tooling. It
uses the direct build engine because the PoP is intentionally small.

Normal entrypoint discovery is:

```text
dsg/openscad/render/*.scad  -> bld/png/*.png
dsg/openscad/export/*.scad  -> bld/stl/*.stl
```

Bootstrap a checkout with:

```bash
bash ./bootstrap.sh
```

or:

```powershell
.\bootstrap.ps1
```

The model and documentation were developed with the assistance of ChatGPT.

# Detachable SCAD clip interface PoP

Proof of Principle for a detachable, printable OpenSCAD attachment interface
inspired by OpenGrid.

The first production driver is the removable aluminium reinforcement-tube clip
for the HUB75 display frame, but this repository deliberately starts with
neutral reference/coupon geometry. Production HUB75 couplers remain owned by
`brainboxemb/2026-009-01.cad.HUB75-display-frame`.

## Current phase

**AT-01 — inside-out OpenGrid Lite receiver with two fixed-side carriers**

One source-derived local mating interface is tested in two mounting contexts:

```text
A  50 × 10 × 4 mm rail carrier
   + one local 10 × 10 mm receiver position

B  50 × 20 × 6 mm base plate
   + 10 × 14 × 4 mm support boss
   + the same central 10 × 10 mm receiver position
```

The removable snap is 10 mm long and uses retention/flex only on two opposite
sides. It clips from above at the one defined receiver position. The local
receiver has an 8 mm active profile with a 1 mm explicit transition at each end back into
the surrounding carrier.

The local X/Z receiver profile and inward snap nubs are intentionally derived
from the QuackWorks OpenGrid Lite receiver + normal snap relationship. See
[AT-01 design record](docs/05-at-01-inverted-core-snap.md).

## Previous reference phase

**OG-02 — Full versus Lite upstream comparison**

OG-01 established the Full reference pair. OG-02 compares that pair against the
upstream Lite receiver/snap before the mechanism is reduced to a neutral coupon.

Full:

- receiver height: 6.8 mm;
- snap height: 6.8 mm.

Lite:

- receiver height: 4.0 mm;
- snap height: 3.4 mm;
- top-flush assembled snap bottom offset: 0.6 mm.

Comparison PNG:

- `og-02-full-lite-assembled.png`
- `og-02-full-lite-exploded.png`
- `og-02-full-lite-section.png`

Individual profile PNG + 1.0 mm profile-slice STL:

- Full receiver;
- Full snap;
- Lite receiver;
- Lite snap.

Printable complete parts:

- existing OG-01 Full receiver/snap STL exports remain the Full baseline;
- `og-02-lite-receiver.stl`;
- `og-02-lite-snap.stl`.

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

1. **OG-01** — reproduce and understand the upstream Full receiver + snap.
2. **OG-02** — compare upstream Full and Lite receiver/snap variants.
3. **AT-01** — reduce the relationship to a neutral fixed/removable coupon.
4. **AT-02** — expose retention/flex geometry and critical dimensions.
5. **AT-03** — compare only the critical tolerance variants.
6. **TC-01** — add the real horizontal tube-clamping function after the
   attachment principle is understood.

See [experiment plan](docs/01-experiment-plan.md).

## Interactive OpenSCAD view

Open `dsg/openscad/main.scad` for local investigation. Its Customizer **View**
selector exposes the stable Full/Lite experiment views directly:

- complete Full and Lite assemblies;
- individual receivers and snaps;
- individual receiver/snap cross-sections;
- selectable center/flex-slot versus solid/off-slot profile plane;
- Full-versus-Lite assembled, exploded and section comparisons;
- AT-01 rail/plate assembled and exploded views, retention sections, individual
  receiver/snap views and a rail-vs-plate comparison.

The individual build entrypoints remain authoritative for generated PNG/STL
evidence; `main.scad` is the convenient interactive selector over the same
experiment geometry.

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

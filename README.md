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
the surrounding carrier. Its final 0.4 mm narrows inward to a 9.2 × 9.2 mm top
footprint so vertical insertion is centring rather than outward-guiding.

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
- basic/QuackWorks Lite snap height: 3.4 mm;
- arithmetic envelope difference: 0.6 mm.

The reference does **not** impose a derived 0.6 mm Z offset. Receiver and snap
are posed using the upstream CENTER anchoring. The 3.4 mm Lite snap is therefore
shown as the actual pinned/basic reference rather than visually stretched to
fill the 4.0 mm receiver envelope.

Generated output names are intentionally user-facing rather than experiment-code
names. Numeric prefixes keep the most useful geometry at the top of the
auto-generated gallery.

The first outputs are:

- `01-reference-lite-receiver.png/.stl`;
- `02-reference-lite-snap.png/.stl`;
- `03-interface-receiver-rail.png/.stl`;
- `04-interface-receiver-plate.png/.stl`;
- `05-interface-snap.png/.stl`.

Assemblies follow in the `10-...` range, exploded/comparison views in the
`20-...` range, interface sections/profiles in the `30-...` range, and
reference/detail evidence afterwards.

Internal labels such as OG-01, OG-02 and AT-01 remain in the experiment records
and testcase discussion, but are deliberately not required to understand a
generated PNG or STL filename.

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
- selectable center/flex-slot versus solid/off-slot profile plane, with the
  solid/off-slot plane as the default because it gives the clearest first
  impression of the complete mating body;
- Full-versus-Lite assembled, exploded and section comparisons;
- AT-01 rail/plate assembled and exploded views, retention sections, individual
  receiver/snap views, a rail-vs-plate comparison and a generated top-view
  comparison for the centring lead-in / 1 mm reference grooves.

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

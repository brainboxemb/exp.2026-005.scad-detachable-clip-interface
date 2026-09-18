# Detachable SCAD clip interface PoP

Proof of Principle for a detachable, printable OpenSCAD attachment interface
inspired by OpenGrid.

The first production driver is the removable aluminium reinforcement-tube clip
for the HUB75 display frame, but this repository deliberately starts with
neutral reference/coupon geometry. Production HUB75 couplers remain owned by
`brainboxemb/2026-009-01.cad.HUB75-display-frame`.

## Current phase

**AT-01 — reduced detachable receiver + snap**

The actual design objects are now separated from their carrier examples:

```text
opengrid-lite-receiver    pinned upstream fixed-side source
opengrid-lite-snap        pinned upstream removable-side source

node-receiver             experiment-owned fixed-side node
node-snap                 experiment-owned removable node

examples/
  receiver-rail           carrier integration example
  receiver-plate          carrier integration example
```

The standalone reduced receiver is a 10 × 14 × 4 mm object: a central 10 mm
functional receiver plus 2 mm top-guide/support transition at each end. The
removable snap is 10 mm long and retains/flexes only on two opposite sides.

The local X/Z receiver profile and inward snap nubs are intentionally derived
from the pinned QuackWorks OpenGrid Lite receiver + normal snap relationship.
See the [AT-01 experiment record](docs/05-at-01-inverted-core-snap.md).

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

- `01-opengrid-lite-receiver.png/.stl`;
- `02-opengrid-lite-snap.png/.stl`;
- `03-node-receiver.png/.stl`;
- `04-node-snap.png/.stl`;
- `10-example-receiver-rail.png/.stl`;
- `11-example-receiver-plate.png/.stl`;
- `12-example-rail-assembled.png`;
- `13-example-plate-assembled.png`.

The primary reference/design objects therefore appear before carrier examples.
Exploded/comparison views follow in the `20-...` range, node
sections/profiles in the `30-...` range, and reference/detail evidence
afterwards.

Internal labels such as OG-01, OG-02 and AT-01 remain in the experiment records
and testcase discussion, but are deliberately not required to understand a
generated PNG or STL filename.

After merge, normal production output is published under:

- [Build](../../tree/prod/bld)
- [PNG gallery](../../blob/prod/bld/png/README.md)
- [STL output](../../tree/prod/bld/stl)


## License

This experiment repository is licensed under the
**Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International**
license (**CC BY-NC-SA 4.0**). See [LICENSE](LICENSE).

The detachable interface geometry in this repository is derived from the pinned
QuackWorks/OpenGrid reference and therefore keeps the upstream attribution and
ShareAlike boundary explicit.

Upstream reference:

```text
OpenGrid design: David D
QuackWorks/OpenSCAD implementation: AndyLevesque/QuackWorks
Pinned commit: e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
Upstream repository licence: CC BY-NC-SA 4.0
```

The pinned third-party source remains in its own submodule/fork boundary and
retains its original copyright and licence notices.


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

## Component design documentation

The component-local design documents are the geometry authority for their
respective objects:

- [OpenGrid Lite receiver](dsg/openscad/components/opengrid-lite-receiver/design/design.md)
- [OpenGrid Lite snap](dsg/openscad/components/opengrid-lite-snap/design/design.md)
- [Node receiver](dsg/openscad/components/node-receiver/design/design.md)
- [Node snap](dsg/openscad/components/node-snap/design/design.md)

Carrier usage lives separately under `dsg/openscad/examples/`. The rail and
plate examples are consumers of the node design, not definitions of it.

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
- node rail/plate assembled and exploded views, retention sections, individual
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

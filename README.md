# Detachable SCAD clip interface PoP

Proof of Principle for a detachable, printable OpenSCAD attachment interface
inspired by OpenGrid.

The first production driver is the removable aluminium reinforcement-tube clip
for the HUB75 display frame, but this repository deliberately starts with
neutral reference/coupon geometry. Production HUB75 couplers remain owned by
`brainboxemb/2026-009-01.cad.HUB75-display-frame`.

## Current phase

**Reduced detachable receiver + snap**

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

The engineering model is deliberately split in two stages. The **interface
specification** defines the source-derived local X/Z mating profile and its
mirrored spacing. A **minimal receiver + minimal snap** then serve as the
reference implementation of that contract.

The transverse X/Z receiver profile is established from the pinned source.
The compact stage-2 receiver is a **centred 10 mm crop from one OpenGrid
straight-edge region**. The minimum source straight half-span is 6.923045 mm,
leaving 1.923045 mm before the separate source corner construction at each crop
end. The 10 mm length remains a reference-implementation choice rather than
part of the interface contract. The snap retains/flexes only on two opposite
sides.

The local X/Z receiver profile and inward snap nubs are intentionally derived
from the pinned QuackWorks OpenGrid Lite receiver + normal snap relationship.
See the [reduced receiver + snap experiment record](docs/05-reduced-receiver-snap.md).

## Two-stage specification and reference design

The authoritative reading order is:

1. [Detachable interface specification](dsg/openscad/specification/specification.md)
   — what the two parts must mate with;
2. [Minimal receiver design](dsg/openscad/components/node-receiver/node_receiver/design/design.md)
   and [minimal snap design](dsg/openscad/components/node-snap/node_snap/design/design.md)
   — one small reference implementation of that contract.

The specification includes a combined contract drawing and a separate
OpenGrid-to-node comparison sheet. The OpenGrid side is explicitly an
experiment interpretation of the pinned source dimensions, **not** an upstream
manufacturing drawing.

The technical-drawing work is currently held at a deliberately small
**geometry reconstruction** checkpoint.  Before dimensions, sections, detail
bubbles or a title block are reintroduced, Python must reproduce the pinned
OpenGrid Lite plan geometry from the same source millimetre dimensions.

The drawing producer now emits:

```text
bld/drawing/00-opengrid-python.svg
bld/drawing/00-opengrid-python.png
bld/drawing/01-opengrid-openscad-reference.svg
bld/drawing/01-opengrid-openscad-reference.png
bld/drawing/02-opengrid-overlay.svg
bld/drawing/02-opengrid-overlay.png
bld/drawing/03-opengrid-straight-crop-proof.svg
bld/drawing/03-opengrid-straight-crop-proof.png
```

The first SVG is the independent Python reconstruction. It keeps the model in
real millimetres and merges the unique horizontal contours at the
source-derived Lite profile edges (1.6, 2.6, 3.6 and 4.0 mm). The 0.0 and
1.6 mm sections are identical and therefore draw the same line only once.

The Python and OpenSCAD SVGs each also get a direct black-and-white PNG review
image. The second SVG cuts the actual pinned OpenGrid Lite model at those same
source-derived heights and validates every raw OpenSCAD section independently.
The final top-view merge is visibility-aware: a lower contour segment is drawn
only where its XY location remains inside every higher opening, so material
above it cannot hide that edge. This removes the artificial line crossings
created by simply stacking complete closed section contours.

The same visibility rule is applied separately to the Python reconstruction and
the validated OpenSCAD section polygons. The overlay then compares the visible
edge endpoints as well as the raw section vertices. OpenSCAD output is never
fed back into the Python source-profile construction.

The fourth artifact shows the limiting source section together with the 10 mm
stage-2 crop. Its numeric gate requires a positive end margin; the current
source-derived margin is 1.923045 mm per end.

No A4 sheet, A-A section, B/C/D detail circles, dimensions or title block belong
to this checkpoint.

## Previous reference work

**Full versus Lite upstream comparison**

The upstream Full reference established the source pair. The subsequent
Full-versus-Lite comparison established which low-profile source relationship
to reduce before creating the neutral receiver/snap coupon.

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

1. **Upstream Full reference** — reproduce and understand the upstream Full receiver + snap.
2. **Full versus Lite comparison** — compare upstream Full and Lite receiver/snap variants.
3. **Reduced receiver + snap** — reduce the relationship to a neutral fixed/removable coupon.
4. **Retention and flex geometry** — expose retention/flex geometry and critical dimensions.
5. **Tolerance qualification** — compare only the critical tolerance variants.
6. **Tube-clip carrier** — add the real horizontal tube-clamping function after the
   attachment principle is understood.

See [experiment plan](docs/01-experiment-plan.md).

## Specification and reference implementation

The interface contract is authoritative for shared mating geometry:

- [Interface specification](dsg/openscad/specification/specification.md)

The minimal stage-2 implementation is documented separately:

- [Node receiver](dsg/openscad/components/node-receiver/node_receiver/design/design.md)
- [Node snap](dsg/openscad/components/node-snap/node_snap/design/design.md)

Pinned-source analysis remains useful provenance/evidence rather than the local
interface contract:

- [OpenGrid Lite receiver](dsg/openscad/components/opengrid-lite-receiver/opengrid_lite_receiver/design/design.md)
- [OpenGrid Lite snap](dsg/openscad/components/opengrid-lite-snap/opengrid_lite_snap/design/design.md)

Carrier usage lives separately under `dsg/openscad/examples/`. The rail and
plate examples are consumers of the reference implementation, not definitions
of the interface.

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
  comparison for the centring lead-in / 1 mm reference grooves;
- an optional interactive X/Y/Z slice around any selected main view, provided
  by the shared `lib.scad.util` `util_section_inspect()` helper, with sliders
  for the section-plane position and retained slice thickness plus
  positive/negative direction. Only the requested slab is retained: for
  example, Z=0 with depth 0.1 mm and Positive keeps Z=0.0..0.1 mm. The
  Customizer block is library-managed and can be refreshed with
  `dsg/openscad/ext/lib.scad.util/consumer/sync-section-inspection.sh
  dsg/openscad/main.scad`.

The individual build entrypoints remain authoritative for generated PNG/STL
evidence; `main.scad` is the convenient interactive selector over the same
experiment geometry.

## Build model

Geometry remains OpenSCAD-first, with the shared SCons backend handling
selective rebuild/cache behavior. The first composed technical drawing uses the
dedicated drawing runtime from `tool.scad-project v0.15.1`:

```text
OpenSCAD pinned/source geometry
    -> project Python + drawsvg
    -> canonical SVG
    -> Python invokes Inkscape
    -> PNG / PDF
```

Normal geometry entrypoint discovery remains:

```text
dsg/openscad/render/*.scad  -> bld/png/*.png
dsg/openscad/export/*.scad  -> bld/stl/*.stl

dsg/drawing/opengrid_profile_geometry.py
    -> source/profile geometry in real millimetres

dsg/drawing/opengrid_profile_render.py
    -> SVG/PNG presentation only

dsg/drawing/build_opengrid_profile.py
    -> OpenSCAD oracle + validation/orchestration
    -> bld/drawing/00-opengrid-python.svg
    -> bld/drawing/01-opengrid-openscad-reference.svg
    -> bld/drawing/02-opengrid-overlay.{svg,png}
```

The drawing migration is currently validating one source-derived OpenGrid Lite
plan outline.  Python reconstructs the footprint from the pinned millimetre
parameters and source construction; a separately generated OpenSCAD projection
is overlaid only as a check.  Engineering-sheet content remains intentionally
out of scope until those two geometries coincide.

Bootstrap a checkout with:

```bash
bash ./bootstrap.sh
```

or:

```powershell
.\bootstrap.ps1
```

The model and documentation were developed with the assistance of ChatGPT.

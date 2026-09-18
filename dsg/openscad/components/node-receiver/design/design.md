# Node receiver — design

<!-- scad-render-defaults
engine: openscad
source: node_receiver_render.scad
module: node_receiver_design
vpr: [68, 0, 28]
-->

## Design intent

The receiver is the fixed half of the node interface. It is designed as a
standalone object first; rail and plate are only later integration examples.

The construction starts from one simple block:

```text
width                  10 mm
length                 14 mm
height                  4 mm
functional zone        10 mm
extra top guide         2 mm at each Y end
```

The 14 mm length is deliberate: the complete 10 mm functional receiver remains
untouched, while the top insertion guide gets real material in which it can
transition back to the normal outer profile.

## Step 1 — start from the neutral block

<!-- scad-render
view: base-block
-->

The base is intentionally boring. All interface behaviour is created
substractively from this block.

The production geometry starts from the same dimensions:

```openscad
translate([
    -NODE_RECEIVER_WIDTH / 2,
    -NODE_RECEIVER_BLOCK_LENGTH / 2,
    0
])
    cube([
        NODE_RECEIVER_WIDTH,
        NODE_RECEIVER_BLOCK_LENGTH,
        NODE_RECEIVER_HEIGHT
    ]);
```

Keeping this as a separate conceptual step makes it easy to see which later
surfaces are functional and which are merely the carrier envelope.

## Step 2 — cut the lower source-derived mating profile

The first functional operation creates the lower receiver profile. In the
design view the still-neutral block is grey and the material that will be
removed is red.

<!-- scad-render
view: lower-cutters
-->

The X/Z profile is the radial mirror of the pinned OpenGrid Lite receiver:

```text
Z 0.0 .. 1.6     width 8.6 mm
Z 1.6 .. 2.6     8.6 -> 10.0 mm
Z 2.6 .. 3.6     width 10.0 mm
```

Along Y the lower profile is 8 mm active and returns to the untouched block over
1 mm on both sides.

The key construction is intentionally symmetric:

```openscad
module node_receiver_design_lower_cutters() {
    union() {
        _node_positive_x_lower_cut_active();
        _node_positive_y_lower_cut_transition();
        mirror([0, 1, 0])
            _node_positive_y_lower_cut_transition();

        mirror([1, 0, 0]) {
            _node_positive_x_lower_cut_active();
            _node_positive_y_lower_cut_transition();
            mirror([0, 1, 0])
                _node_positive_y_lower_cut_transition();
        }
    }
}
```

After the cut:

<!-- scad-render
view: after-lower
-->

This step is the retention/capture body. It should not be reshaped merely to
make the top look nicer.

## Step 3 — add the 10 mm main top lead-in

Insertion guidance is a separate problem from lower retention. The snap is
open at both Y ends and flexes/retains only on +/-X, so the receiver top guide
is deliberately **two-sided** rather than a four-sided funnel. The complete
main X-side guide spans the full functional receiver length from Y=-5 to Y=+5.

The material removed by this step is highlighted in red:

<!-- scad-render
view: top-main-cutters
-->

Its X/Z section is:

```text
Z = 3.6 mm     outer width 10.0 mm
Z = 4.0 mm     top width    9.2 mm
```

So each X side has a 0.4 × 0.4 mm lead-in. The corresponding production cutter
is a triangular extrusion:

```openscad
linear_extrude(
    height = NODE_RECEIVER_TOP_GUIDE_ACTIVE_LENGTH, // 10 mm
    center = true
)
    polygon(points = [
        [NODE_RECEIVER_TOP_WIDTH / 2, NODE_RECEIVER_HEIGHT],
        [NODE_RECEIVER_WIDTH / 2,         NODE_RECEIVER_HEIGHT],
        [NODE_RECEIVER_WIDTH / 2,         NODE_RECEIVER_CAPTURE_TOP_Z]
    ]);
```

After the main lead-in:

<!-- scad-render
view: after-top-main
-->

The important point is that this 10 mm face is complete. There is no separate
+/-Y capture chamfer competing with it. End guidance is added outside the
functional zone rather than shortening the main face.

## Step 4 — taper the lead-in into the 14 mm block

This is the part currently under the closest visual review.

At Y=±5 the complete triangular X/Z lead-in exists. Between Y=±5 and Y=±7 it
returns to the untouched outer/top corner of the block. Because no separate
Y-side top cut overlaps this transition anymore, the end guide is one clean
three-dimensional taper. The extra end-guide cutters are shown in red:

<!-- scad-render
view: top-end-cutters
-->

For one positive-X / positive-Y corner the intended points are:

```text
A = (X=4.6, Y=5, Z=4.0)
B = (X=5.0, Y=5, Z=4.0)
C = (X=5.0, Y=5, Z=3.6)
D = (X=5.0, Y=7, Z=4.0)
```

The current construction is therefore a tetrahedral cut:

```openscad
polyhedron(
    points = [
        [xi, ya, z1],   // A
        [xo, ya, z1],   // B
        [xo, ya, z0],   // C
        [xo, yb, z1]    // D
    ],
    faces = [
        [0, 2, 1],
        [0, 1, 3],
        [1, 2, 3],
        [2, 0, 3]
    ]
);
```

The design acceptance criterion is visible rather than merely numerical:

> the 10 mm main lead-in may not end against a vertical wall; both Y ends must
> visibly continue through one sloped guide surface into the ordinary block.

This also preserves the intended open-ended behaviour of the snap: the receiver
guides laterally in X without introducing an unnecessary Y capture wall.

## Step 5 — inspect the functional receiver without scale marks

<!-- scad-render
view: plain
-->

This is the clean geometry that must be judged for insertion and retention.

The receiver is deliberately evaluated in this form before carrier integration.
If this standalone object is not coherent, a rail or plate must not hide the
problem.

## Step 6 — add the optional 1 mm reference grooves

The millimetre pattern is physical but non-functional. Existing receiver
geometry is grey; the groove cutters are red.

<!-- scad-render
view: pattern-cutters
-->

The same helper is used by receiver and snap:

```openscad
_node_mm_reference_cuts_at_top(
    NODE_RECEIVER_HEIGHT,
    NODE_RECEIVER_WIDTH,
    NODE_RECEIVER_BLOCK_LENGTH
);
```

The principal lines run to the real part boundary. The 1 mm ticks continue over
the available length and are clipped naturally by the part outline.

## Final design object

<!-- scad-render
view: final
-->

This object — not the later rail or plate — is the fixed-side interface
definition.

## Integration boundary

Consumers may embed this receiver into a rail, plate, HUB75 coupler or another
part, but integration must not silently change its mating profile. Carrier
examples live separately under `dsg/openscad/examples/`.

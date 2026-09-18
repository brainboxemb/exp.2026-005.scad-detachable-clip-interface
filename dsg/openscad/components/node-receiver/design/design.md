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
length                 10 mm
height                  4 mm
functional zone        10 mm
top guide length        10 mm
top narrowing       10.0 -> 9.2 mm over 0.4 mm Z
```

The guide stays inside the same 10 mm footprint as the receiver and snap. The
same X/Z insertion chamfer runs over the complete 10 mm Y length. There is no
separate Y taper: the snap is open at both Y ends, so only the +/-X faces need
to guide the part inward.

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

## Step 3 — define the X/Z insertion lead-in

Insertion guidance is separate from lower retention. The node snap is open at
both Y ends and flexes/retains only on +/-X, so the receiver only needs a
two-sided X/Z guide.

The red volume below is a **1 mm analysis slice of the real production cutter**:

<!-- scad-render
view: top-profile-slice
-->

Its X/Z section is:

```text
Z = 3.6 mm     outer width 10.0 mm
Z = 4.0 mm     top width    9.2 mm
```

Each X side therefore has a 0.4 × 0.4 mm lead-in. The design helper obtains the
slice by intersecting the real production cutter; it does not redraw the
profile separately.

## Step 4 — extend that same profile over the full 10 mm length

The complete top cutter is that same triangular X/Z section linearly extruded
over the receiver length:

<!-- scad-render
view: top-guide-cutter
-->

```openscad
rotate([90, 0, 0])
    linear_extrude(
        height = NODE_RECEIVER_TOP_GUIDE_LENGTH + 0.02,
        center = true
    )
        polygon(points = [
            [NODE_RECEIVER_TOP_WIDTH / 2, NODE_RECEIVER_HEIGHT + 0.01],
            [NODE_RECEIVER_WIDTH / 2 + 0.01, NODE_RECEIVER_HEIGHT + 0.01],
            [NODE_RECEIVER_WIDTH / 2 + 0.01, NODE_RECEIVER_CAPTURE_TOP_Z]
        ]);
```

There is deliberately no Y taper to a point. The earlier 6 mm + 2 mm end
transition construction created an hourglass top view, a V-shaped side profile
and thin end fins. Those were cutter artifacts, not useful centering geometry.

### 4a — before the top-guide subtraction

<!-- scad-render
view: top-guide-before
-->

### 4b — exact material removed by the top guide

The grey receiver is shown on the left. On the right, red is **only the exact
intersection of the real top-guide cutter with that receiver**:

<!-- scad-render
view: top-guide-removed
-->

The objects are separated only for readability; overlaying a 0.4 mm removed
volume on the same surface caused z-fighting/occlusion and made the old image
misleading.

### 4c — result after one subtraction

<!-- scad-render
view: top-guide-after
-->

For direct comparison:

<!-- scad-render
view: top-guide-before-after
-->

Acceptance conditions:

- the X/Z guide is constant over the complete 10 mm Y length;
- the top width is 9.2 mm and the capture width below it remains 10.0 mm;
- the top plan is not hourglass-shaped;
- the Y side view has no V-shaped top and no thin end fins;
- no separate +/-Y capture chamfer is introduced.

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

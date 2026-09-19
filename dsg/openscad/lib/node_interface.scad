// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// This file contains experiment geometry derived from the OpenGrid/QuackWorks
// reference. Original OpenGrid design: David D.
// QuackWorks/OpenSCAD reference: AndyLevesque/QuackWorks,
// pinned at e0c1cb7ec78dd9e9a8476ed739bd3402074354f3.
// See LICENSE and docs/00-source-provenance.md for attribution and provenance.
//
// File: detachable_node_interface.scad
// Node interface — fixed receiver and removable snap.
//
// The local X/Z mating profile is intentionally derived from the QuackWorks
// OpenGrid Lite receiver + normal snap relationship at:
//   AndyLevesque/QuackWorks
//   e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
//
// Roles are inverted radially:
//   OpenGrid receiver inner wall -> node receiver outer wall
//   OpenGrid snap outward nub    -> node snap inward nub
//
// The receiver is LOCAL: one 10 x 10 mm attachment zone in the middle of each
// 50 mm carrier. Only the two +/-X sides retain/flex. The snap is open at both
// Y ends and clips on locally from above.

// BOSL2 is used for rounded click-slot cuts.
include <BOSL2/std.scad>

// Primary node-receiver envelope.
NODE_RECEIVER_WIDTH = 10.0;
NODE_RECEIVER_HEIGHT = 4.0;

// Example carrier dimensions. Examples consume the node dimensions rather than
// defining them.
EXAMPLE_CARRIER_LENGTH = 50.0;
EXAMPLE_RAIL_WIDTH = NODE_RECEIVER_WIDTH;
EXAMPLE_RAIL_HEIGHT = NODE_RECEIVER_HEIGHT;

EXAMPLE_PLATE_WIDTH = 20.0;
EXAMPLE_PLATE_HEIGHT = 6.0;

// Local receiver footprint along the carrier.
// OpenGrid keeps one X/Z edge profile constant along each straight tile edge.
// The node baseline does the same: the only experiment-owned Y dimension is
// the length of this straight coupon path.
NODE_RECEIVER_FUNCTIONAL_LENGTH = 10.0;
NODE_RECEIVER_BLOCK_LENGTH = NODE_RECEIVER_FUNCTIONAL_LENGTH; // 10 mm

// Removable snap length matches the local receiver footprint.
NODE_SNAP_LENGTH = 10.0;

// OpenGrid Lite source dimensions used by the radial mirror.
OPENGRID_RECEIVER_CAPTURE_WIDTH = 25.0;
OPENGRID_RECEIVER_LOWER_WIDTH = 26.4;
OPENGRID_RECEIVER_TOP_WIDTH = 25.8;
OPENGRID_SNAP_BODY_WIDTH = 24.8;
OPENGRID_SNAP_NUB_OUTER_WIDTH = 25.6;

// Mirror constant: original narrow 25 mm opening becomes 10 mm fixed capture.
NODE_RADIAL_MIRROR_SUM =
    OPENGRID_RECEIVER_CAPTURE_WIDTH + NODE_RECEIVER_WIDTH;

// Mirrored fixed-receiver profile widths.
NODE_RECEIVER_LOWER_WIDTH =
    NODE_RADIAL_MIRROR_SUM - OPENGRID_RECEIVER_LOWER_WIDTH; // 8.6
NODE_RECEIVER_TOP_WIDTH =
    NODE_RADIAL_MIRROR_SUM - OPENGRID_RECEIVER_TOP_WIDTH;  // 9.2

// Mirrored snap inner widths.
NODE_SNAP_INNER_WIDTH =
    NODE_RADIAL_MIRROR_SUM - OPENGRID_SNAP_BODY_WIDTH;     // 10.2
NODE_SNAP_NUB_OPENING =
    NODE_RADIAL_MIRROR_SUM - OPENGRID_SNAP_NUB_OUTER_WIDTH;      // 9.4
NODE_SNAP_NUB_PROTRUSION =
    (NODE_SNAP_INNER_WIDTH - NODE_SNAP_NUB_OPENING) / 2; // 0.4

// Lite receiver X/Z profile after taking the upper 4.0 mm of the Full board.
// Radially mirrored fixed receiver:
//   z 0.0 .. 1.6   width 8.6
//   z 1.6 .. 2.6   ramp 8.6 -> 10.0
//   z 2.6 .. 3.6   width 10.0
//   z 3.6 .. 4.0   ramp 10.0 -> 9.2
NODE_RECEIVER_LOWER_Z = 1.6;
NODE_RECEIVER_RAMP_TOP_Z = 2.6;
NODE_RECEIVER_CAPTURE_TOP_Z = 3.6;

// The pinned Lite reference assembles receiver and snap at the same CENTER
// origin. The 0.6 mm difference between 4.0 mm receiver height and 3.4 mm
// engagement height is arithmetic only; it is not a proven seated Z offset.
NODE_SNAP_SEATED_Z = 0.0;
NODE_SNAP_ENGAGEMENT_HEIGHT = 3.4;
NODE_SNAP_RECEIVER_HEIGHT_DIFFERENCE =
    NODE_RECEIVER_HEIGHT - NODE_SNAP_ENGAGEMENT_HEIGHT; // 0.6 mm

// Radial flex-wall decomposition.
//
// Upstream normal snap:
//   body outer face      x = 12.4
//   click-slot center    x = 11.4
//   click-slot width         0.6
//
// Therefore the nub-bearing flex tongue between body face and slot is:
//   12.4 - (11.4 + 0.3) = 0.7 mm.
//
// The radial mirror keeps that 0.7 mm tongue on the INSIDE of our shell.
// The 0.6 mm slot and its 0.3 mm rounding are also kept unchanged.
// Material beyond the slot is experiment-owned support; start at 0.7 mm so
// the first coupon has a symmetric 0.7 / 0.6 / 0.7 radial wall stack.
NODE_SNAP_FLEX_TONGUE_THICKNESS = 0.7;
NODE_SNAP_CLICK_SLOT_WIDTH = 0.6;
NODE_SNAP_CLICK_SLOT_CORNER_RADIUS = 0.3;
NODE_SNAP_OUTER_SUPPORT_THICKNESS = 0.7;

NODE_SNAP_WALL_THICKNESS =
    NODE_SNAP_FLEX_TONGUE_THICKNESS + NODE_SNAP_CLICK_SLOT_WIDTH + NODE_SNAP_OUTER_SUPPORT_THICKNESS; // 2.0
NODE_SNAP_TOP_THICKNESS = 1.2;
NODE_SNAP_OUTER_WIDTH = NODE_SNAP_INNER_WIDTH + 2 * NODE_SNAP_WALL_THICKNESS;
NODE_SNAP_TOTAL_HEIGHT = NODE_SNAP_ENGAGEMENT_HEIGHT + NODE_SNAP_TOP_THICKNESS;

// Normal OpenGrid snap nub dimensions, radially mirrored.
// Z/radial dimensions stay at upstream values; tangential length scales with
// the 25 -> 10 mm receiver width reduction.
NODE_TANGENTIAL_SCALE =
    NODE_RECEIVER_WIDTH / OPENGRID_RECEIVER_CAPTURE_WIDTH; // 0.4

// OpenGrid uses a chamfered/rounded plan form on the snap top rather than a
// plain rectangular slab. Scale the source 3.262743 mm plan chamfer with the
// same 25 -> 10 mm reduction used for tangential dimensions.
OPENGRID_SNAP_CORE_CHAMFER = 4.81837;
OPENGRID_SNAP_TOP_CHAMFER = 3.262743;

// Normal OpenGrid nub source dimensions used by the node snap.
OPENGRID_SNAP_NUB_HEIGHT = 0.2;
OPENGRID_SNAP_NUB_WIDTH = 11.0;
OPENGRID_SNAP_NUB_DEPTH = 0.4;
OPENGRID_SNAP_NUB_TOP_WEDGE_HEIGHT = 0.6;
OPENGRID_SNAP_NUB_BOTTOM_WEDGE_HEIGHT = 0.6;
OPENGRID_SNAP_NUB_ROUND_X = -12.36;
OPENGRID_SNAP_NUB_ROUND_SCALE_Y = 1.36;
OPENGRID_SNAP_NUB_ROUND_RADIUS = 13.025;
// A direct 25 -> 10 mm scale gives ~1.93 mm, which consumes almost the entire
// 2.0 mm wall at the open end. Keep the source 45-degree corner language, but
// cap the reduced chamfer at half the wall thickness so the end retains a
// visible straight segment as well.
NODE_SNAP_CORNER_CHAMFER = min(
    OPENGRID_SNAP_CORE_CHAMFER * NODE_TANGENTIAL_SCALE,
    NODE_SNAP_WALL_THICKNESS / 2
);

// Top and core deliberately use this same chamfer so the outside contour
// remains continuous from the engagement body into the top.

// OpenGrid click-hole proportions retained on +/-X only.
// Radial width and rounding are source values. Tangential length is shortened
// for this 10 mm coupon while preserving the 11/12.4 nub/slot relationship.
NODE_SNAP_CLICK_SLOT_LENGTH = 12.4 * NODE_TANGENTIAL_SCALE;         // 4.96
NODE_SNAP_CLICK_SLOT_HEIGHT = 1.5;
NODE_SNAP_CLICK_SLOT_OFFSET_FROM_INNER =
    NODE_SNAP_FLEX_TONGUE_THICKNESS + NODE_SNAP_CLICK_SLOT_WIDTH / 2;          // 1.0

NODE_SNAP_TOP_SLOT_WIDTH = 1.4;
NODE_SNAP_TOP_SLOT_LENGTH = 12.0 * NODE_TANGENTIAL_SCALE;           // 4.8
NODE_SNAP_TOP_SLOT_HEIGHT = 0.4;
NODE_SNAP_TOP_SLOT_Z = 2.2;

// Evidence helpers.
EVIDENCE_EXPLODED_Z = 8.0;
EVIDENCE_PROFILE_SLICE = 1.0;
EVIDENCE_TRANSITION_PLAN_Z = 0.8;

// Optional physical millimetre reference grooves.
// These are real subtractive features so they appear in STL as well as render.
// The reference is deliberately compact: one centred 10 x 10 mm "centimetre"
// patch, rather than a grid spread over the complete receiver/support area.
NODE_MM_PATTERN_PITCH = 1.0;
NODE_MM_PATTERN_DEPTH = 0.12;
NODE_MM_PATTERN_LINE_WIDTH = 0.12;
NODE_MM_PATTERN_TICK_LENGTH = 0.55;
NODE_MM_PATTERN_TICK_WIDTH = 0.10;

// Invariants.
assert(abs(NODE_RECEIVER_WIDTH - 10.0) < 0.0001);
assert(abs(NODE_RECEIVER_LOWER_WIDTH - 8.6) < 0.0001);
assert(abs(NODE_RECEIVER_TOP_WIDTH - 9.2) < 0.0001);
assert(abs(NODE_SNAP_INNER_WIDTH - 10.2) < 0.0001);
assert(abs(NODE_SNAP_NUB_OPENING - 9.4) < 0.0001);
assert(abs(NODE_SNAP_NUB_PROTRUSION - 0.4) < 0.0001);
assert(abs(NODE_SNAP_FLEX_TONGUE_THICKNESS - 0.7) < 0.0001);
assert(abs(NODE_SNAP_CLICK_SLOT_WIDTH - 0.6) < 0.0001);
assert(abs(NODE_SNAP_CLICK_SLOT_CORNER_RADIUS - 0.3) < 0.0001);
assert(abs(NODE_SNAP_WALL_THICKNESS - 2.0) < 0.0001);
assert(abs(NODE_SNAP_CORNER_CHAMFER - NODE_SNAP_WALL_THICKNESS / 2) < 0.0001);
assert(NODE_SNAP_CORNER_CHAMFER < NODE_SNAP_LENGTH / 2);
assert(abs(NODE_RECEIVER_FUNCTIONAL_LENGTH - 10.0) < 0.0001);
assert(abs(NODE_RECEIVER_BLOCK_LENGTH - 10.0) < 0.0001);
assert(abs(NODE_SNAP_SEATED_Z) < 0.0001);
assert(abs(NODE_SNAP_RECEIVER_HEIGHT_DIFFERENCE - 0.6) < 0.0001);

// --- Public dimension API for component/design wrappers ----------------------
//
// OpenSCAD use<> imports functions/modules but not top-level variables. Keep
// external wrappers tied to the production constants through these accessors
// rather than duplicating dimensions.

function node_receiver_width() = NODE_RECEIVER_WIDTH;
function node_receiver_length() = NODE_RECEIVER_BLOCK_LENGTH;
function node_receiver_height() = NODE_RECEIVER_HEIGHT;
function node_receiver_functional_length() = NODE_RECEIVER_FUNCTIONAL_LENGTH;

function node_snap_length() = NODE_SNAP_LENGTH;
function node_snap_outer_width() = NODE_SNAP_OUTER_WIDTH;
function node_snap_total_height() = NODE_SNAP_TOTAL_HEIGHT;

// --- Source-derived receiver profile ----------------------------------------
//
// OpenGrid creates its fixed-side edge by defining one 2D radial/Z profile and
// applying BOSL2 path_extrude2d() along a straight tile edge. OpenGrid Lite
// keeps the upper 4.0 mm of that same profile.
//
// The node receiver preserves that construction principle. The radial mirror
// changes only the X widths; the Z bands remain the pinned Lite values:
//
//   z 0.0 .. 1.6   width 8.6
//   z 1.6 .. 2.6   ramp 8.6 -> 10.0
//   z 2.6 .. 3.6   width 10.0
//   z 3.6 .. 4.0   ramp 10.0 -> 9.2
//
// Crucially, this profile is CONSTANT along Y. The 10 mm Y length is merely
// the experiment coupon path length; there is no invented end fade.

function _node_receiver_profile_points() = [
    [-NODE_RECEIVER_LOWER_WIDTH / 2, 0],
    [ NODE_RECEIVER_LOWER_WIDTH / 2, 0],
    [ NODE_RECEIVER_LOWER_WIDTH / 2, NODE_RECEIVER_LOWER_Z],
    [ NODE_RECEIVER_WIDTH / 2,       NODE_RECEIVER_RAMP_TOP_Z],
    [ NODE_RECEIVER_WIDTH / 2,       NODE_RECEIVER_CAPTURE_TOP_Z],
    [ NODE_RECEIVER_TOP_WIDTH / 2,   NODE_RECEIVER_HEIGHT],
    [-NODE_RECEIVER_TOP_WIDTH / 2,   NODE_RECEIVER_HEIGHT],
    [-NODE_RECEIVER_WIDTH / 2,       NODE_RECEIVER_CAPTURE_TOP_Z],
    [-NODE_RECEIVER_WIDTH / 2,       NODE_RECEIVER_RAMP_TOP_Z],
    [-NODE_RECEIVER_LOWER_WIDTH / 2, NODE_RECEIVER_LOWER_Z]
];

module _node_receiver_profile_2d() {
    polygon(points = _node_receiver_profile_points());
}

module _node_receiver_profile_extrusion(length = NODE_RECEIVER_BLOCK_LENGTH) {
    // With the path running BACK (-Y), path_extrude2d maps the profile's first
    // coordinate to X and second coordinate to Z, matching OpenGrid's own
    // straight-edge construction.
    path = [
        [0,  length / 2],
        [0, -length / 2]
    ];

    path_extrude2d(path)
        _node_receiver_profile_2d();
}

// Integration helper only. Carrier examples subtract the exact complement of
// the standalone receiver inside its 10 x 10 x 4 envelope, rather than
// reimplementing the mating profile with a second cutter construction.
module _node_receiver_cuts() {
    difference() {
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

        _node_receiver_profile_extrusion();
    }
}

// --- Optional physical millimetre reference pattern ------------------------

module _node_mm_reference_cuts_at_top(top_z, x_length, y_length) {
    z_center =
        top_z - NODE_MM_PATTERN_DEPTH / 2 + 0.01;

    // Let the two main grooves run all the way to the real part boundary.
    // A tiny overrun guarantees the subtraction reaches the outside face;
    // intersection with the part naturally clips chamfered outlines.
    translate([0, 0, z_center])
        cube([
            x_length + 0.02,
            NODE_MM_PATTERN_LINE_WIDTH,
            NODE_MM_PATTERN_DEPTH + 0.02
        ], center = true);

    translate([0, 0, z_center])
        cube([
            NODE_MM_PATTERN_LINE_WIDTH,
            y_length + 0.02,
            NODE_MM_PATTERN_DEPTH + 0.02
        ], center = true);

    // 1 mm ticks continue over the available line length. The owning part
    // clips ticks automatically at chamfers and outer boundaries.
    x_tick_max = floor(x_length / 2 / NODE_MM_PATTERN_PITCH);
    y_tick_max = floor(y_length / 2 / NODE_MM_PATTERN_PITCH);

    for (i = [-x_tick_max : 1 : x_tick_max])
        if (i != 0)
            translate([i * NODE_MM_PATTERN_PITCH, 0, z_center])
                cube([
                    NODE_MM_PATTERN_TICK_WIDTH,
                    NODE_MM_PATTERN_TICK_LENGTH,
                    NODE_MM_PATTERN_DEPTH + 0.02
                ], center = true);

    for (i = [-y_tick_max : 1 : y_tick_max])
        if (i != 0)
            translate([0, i * NODE_MM_PATTERN_PITCH, z_center])
                cube([
                    NODE_MM_PATTERN_TICK_LENGTH,
                    NODE_MM_PATTERN_TICK_WIDTH,
                    NODE_MM_PATTERN_DEPTH + 0.02
                ], center = true);
}

// --- Standalone receiver block ---------------------------------------------
//
// Primary fixed-side design object. The complete receiver is one constant
// source-derived X/Z profile extruded along a straight 10 mm Y path. Rail and
// plate carriers are integration examples built around this same geometry.

module _node_receiver_geometry() {
    _node_receiver_profile_extrusion();
}

module node_receiver(mm_pattern = false) {
    difference() {
        _node_receiver_geometry();

        if (mm_pattern)
            _node_mm_reference_cuts_at_top(
                NODE_RECEIVER_HEIGHT,
                NODE_RECEIVER_WIDTH,
                NODE_RECEIVER_BLOCK_LENGTH
            );
    }
}

// --- Carrier A: 50 x 10 x 4 rail with one local receiver zone --------------

module _node_receiver_rail_example_geometry() {
    difference() {
        translate([
            -EXAMPLE_RAIL_WIDTH / 2,
            -EXAMPLE_CARRIER_LENGTH / 2,
            0
        ])
            cube([
                EXAMPLE_RAIL_WIDTH,
                EXAMPLE_CARRIER_LENGTH,
                EXAMPLE_RAIL_HEIGHT
            ]);

        _node_receiver_cuts();
    }
}

module node_receiver_rail_example(mm_pattern = false) {
    difference() {
        _node_receiver_rail_example_geometry();

        if (mm_pattern)
            _node_mm_reference_cuts_at_top(
                NODE_RECEIVER_HEIGHT,
                EXAMPLE_RAIL_WIDTH,
                EXAMPLE_CARRIER_LENGTH
            );
    }
}

// --- Carrier B: 50 x 20 x 6 plate + 10 x 10 x 4 support boss --------------

module _node_receiver_plate_example_geometry() {
    union() {
        translate([
            -EXAMPLE_PLATE_WIDTH / 2,
            -EXAMPLE_CARRIER_LENGTH / 2,
            0
        ])
            cube([
                EXAMPLE_PLATE_WIDTH,
                EXAMPLE_CARRIER_LENGTH,
                EXAMPLE_PLATE_HEIGHT
            ]);

        translate([0, 0, EXAMPLE_PLATE_HEIGHT])
            _node_receiver_geometry();
    }
}

module node_receiver_plate_example(mm_pattern = false) {
    difference() {
        _node_receiver_plate_example_geometry();

        if (mm_pattern)
            _node_mm_reference_cuts_at_top(
                EXAMPLE_PLATE_HEIGHT + NODE_RECEIVER_HEIGHT,
                NODE_RECEIVER_WIDTH,
                NODE_RECEIVER_BLOCK_LENGTH
            );
    }
}

function node_example_receiver_base_z(variant) =
    variant == 0 ? 0 : EXAMPLE_PLATE_HEIGHT;

module node_example_receiver(variant = 0, mm_pattern = false) {
    assert(variant == 0 || variant == 1, "node receiver example variant must be 0 or 1.");

    if (variant == 0)
        node_receiver_rail_example(mm_pattern);
    else
        node_receiver_plate_example(mm_pattern);
}

// --- Shared removable snap -------------------------------------------------

module _node_snap_core_outer_envelope() {
    // QuackWorks forms the Lite core with a chamfered plan outline:
    // cuboid(... rounding=4.81837, edges="Z", $fn=2).
    //
    // Keep that plan-form logic under the 25 -> 10 mm reduction so the
    // reduced snap has the same recognisable clipped-corner silhouette.
    cuboid(
        [
            NODE_SNAP_OUTER_WIDTH,
            NODE_SNAP_LENGTH,
            NODE_SNAP_ENGAGEMENT_HEIGHT
        ],
        rounding = NODE_SNAP_CORNER_CHAMFER,
        edges = "Z",
        $fn = 2,
        anchor = BOTTOM
    );
}

module _node_snap_side_wall(x_sign = 1) {
    inner = NODE_SNAP_INNER_WIDTH / 2;
    outer = NODE_SNAP_OUTER_WIDTH / 2;

    intersection() {
        translate([
            x_sign * (inner + outer) / 2,
            0,
            NODE_SNAP_ENGAGEMENT_HEIGHT / 2
        ])
            cube([
                NODE_SNAP_WALL_THICKNESS,
                NODE_SNAP_LENGTH,
                NODE_SNAP_ENGAGEMENT_HEIGHT
            ], center = true);

        _node_snap_core_outer_envelope();
    }
}

module _node_snap_top() {
    translate([
        0,
        0,
        NODE_SNAP_ENGAGEMENT_HEIGHT + NODE_SNAP_TOP_THICKNESS / 2
    ])
        cuboid(
            [
                NODE_SNAP_OUTER_WIDTH,
                NODE_SNAP_LENGTH,
                NODE_SNAP_TOP_THICKNESS
            ],
            rounding = NODE_SNAP_CORNER_CHAMFER,
            edges = "Z",
            $fn = 2,
            anchor = CENTER
        );
}

// Exact radial/Z construction used by the normal QuackWorks OpenGrid nub,
// expressed in local coordinates with the snap body face at X=0.
//
// The node interface deliberately does NOT replace this with a simple trapezoid: that older
// reduction created the visually wrong straight middle section. The PoP keeps
// the source 0.4 mm radial depth and 0.2/0.6/0.6 mm Z wedge relationship, then
// scales only the tangential Y direction by NODE_TANGENTIAL_SCALE.
module _node_source_nub_box() {
    translate([0, 0, OPENGRID_SNAP_NUB_HEIGHT - 0.01])
        cuboid(
            [
                OPENGRID_SNAP_NUB_DEPTH,
                OPENGRID_SNAP_NUB_WIDTH,
                2.0 - OPENGRID_SNAP_NUB_HEIGHT + 0.01
            ],
            anchor = CENTER + LEFT + BOTTOM
        );
}

module _node_source_nub_top_wedge() {
    translate([0, 0, 2.0])
        rotate([0, 180, 90])
            wedge(
                [
                    OPENGRID_SNAP_NUB_WIDTH,
                    OPENGRID_SNAP_NUB_DEPTH,
                    OPENGRID_SNAP_NUB_TOP_WEDGE_HEIGHT
                ],
                anchor = CENTER + BOTTOM + BACK
            );
}

module _node_source_nub_bottom_wedge() {
    translate([0, 0, OPENGRID_SNAP_NUB_HEIGHT])
        rotate([0, 0, 90])
            wedge(
                [
                    OPENGRID_SNAP_NUB_WIDTH,
                    0.4,
                    OPENGRID_SNAP_NUB_BOTTOM_WEDGE_HEIGHT
                ],
                anchor = CENTER + BOTTOM + BACK
            );
}

module _node_source_nub_wedge_shaped() {
    difference() {
        _node_source_nub_box();
        _node_source_nub_top_wedge();
        _node_source_nub_bottom_wedge();
    }
}

module _node_source_nub_rounding_volume() {
    translate([OPENGRID_SNAP_NUB_ROUND_X, 0, 0])
        scale([1, OPENGRID_SNAP_NUB_ROUND_SCALE_Y, 1])
            cyl(
                $fn = 180,
                r = OPENGRID_SNAP_NUB_ROUND_RADIUS,
                h = 2.01,
                anchor = BOTTOM
            );
}

module _node_source_nub_local() {
    intersection() {
        _node_source_nub_wedge_shaped();
        _node_source_nub_rounding_volume();
    }
}

module _node_positive_x_nub_transform() {
    inner = NODE_SNAP_INNER_WIDTH / 2;

    // The upstream nub grows outward from the body face. Mirror that radial
    // direction so it grows inward into the node snap opening. Scale only Y.
    translate([inner + 0.01, 0, 0])
        mirror([1, 0, 0])
            scale([1, NODE_TANGENTIAL_SCALE, 1])
                children();
}

module _node_positive_x_nub() {
    _node_positive_x_nub_transform()
        _node_source_nub_local();
}

module _node_positive_x_click_slot() {
    inner = NODE_SNAP_INNER_WIDTH / 2;

    translate([
        inner + NODE_SNAP_CLICK_SLOT_OFFSET_FROM_INNER,
        0,
        NODE_SNAP_CLICK_SLOT_HEIGHT / 2
    ])
        cuboid(
            [
                NODE_SNAP_CLICK_SLOT_WIDTH,
                NODE_SNAP_CLICK_SLOT_LENGTH,
                NODE_SNAP_CLICK_SLOT_HEIGHT
            ],
            rounding = NODE_SNAP_CLICK_SLOT_CORNER_RADIUS,
            edges = "Z",
            anchor = CENTER
        );
}

module _node_positive_x_top_slot() {
    inner = NODE_SNAP_INNER_WIDTH / 2;

    translate([
        inner,
        0,
        NODE_SNAP_TOP_SLOT_Z + NODE_SNAP_TOP_SLOT_HEIGHT / 2
    ])
        cube([
            NODE_SNAP_TOP_SLOT_WIDTH,
            NODE_SNAP_TOP_SLOT_LENGTH,
            NODE_SNAP_TOP_SLOT_HEIGHT
        ], center = true);
}

module node_snap(mm_pattern = false) {
    difference() {
        union() {
            _node_snap_side_wall(1);
            _node_snap_side_wall(-1);
            _node_snap_top();

            _node_positive_x_nub();

            mirror([1, 0, 0])
                _node_positive_x_nub();
        }

        _node_positive_x_click_slot();
        _node_positive_x_top_slot();

        mirror([1, 0, 0]) {
            _node_positive_x_click_slot();
            _node_positive_x_top_slot();
        }

        if (mm_pattern)
            _node_mm_reference_cuts_at_top(
                NODE_SNAP_TOTAL_HEIGHT,
                NODE_SNAP_OUTER_WIDTH,
                NODE_SNAP_LENGTH
            );
    }
}

// --- Assemblies ------------------------------------------------------------

module node_example_assembled(variant = 0, snap_alpha = 0.55, mm_pattern = false) {
    base_z = node_example_receiver_base_z(variant);

    color([0.68, 0.70, 0.74])
        node_example_receiver(variant, mm_pattern);

    translate([0, 0, base_z + NODE_SNAP_SEATED_Z])
        color([0.92, 0.30, 0.12, snap_alpha])
            node_snap(mm_pattern);
}

module node_example_exploded(variant = 0, mm_pattern = false) {
    base_z = node_example_receiver_base_z(variant);

    color([0.68, 0.70, 0.74])
        node_example_receiver(variant, mm_pattern);

    translate([
        0,
        0,
        base_z + NODE_SNAP_SEATED_Z + EVIDENCE_EXPLODED_Z
    ])
        color([0.92, 0.30, 0.12])
            node_snap(mm_pattern);
}

module node_examples_comparison(mm_pattern = false) {
    translate([-16, 0, 0])
        node_example_assembled(0, mm_pattern = mm_pattern);

    translate([16, 0, 0])
        node_example_assembled(1, mm_pattern = mm_pattern);
}

// --- Evidence sections -----------------------------------------------------

module _node_y_slice() {
    translate([-30, -EVIDENCE_PROFILE_SLICE / 2, -1])
        cube([60, EVIDENCE_PROFILE_SLICE, 20]);
}

module _node_transition_plan_slice(variant = 0) {
    base_z = node_example_receiver_base_z(variant);

    // A horizontal 1 mm slice entirely inside the receiver's lower constant-
    // width band (0 .. 1.6 mm local Z). This exposes the Y lead-in/lead-out
    // directly in plan view without the misleading near-edge X/Z cut.
    translate([
        -30,
        -30,
        base_z + EVIDENCE_TRANSITION_PLAN_Z - EVIDENCE_PROFILE_SLICE / 2
    ])
        cube([60, 60, EVIDENCE_PROFILE_SLICE]);
}

module node_receiver_retention_profile(variant = 0) {
    intersection() {
        node_example_receiver(variant);
        _node_y_slice();
    }
}

module node_snap_retention_profile() {
    intersection() {
        node_snap();
        _node_y_slice();
    }
}

module node_receiver_transition_profile(variant = 0) {
    intersection() {
        node_example_receiver(variant);
        _node_transition_plan_slice(variant);
    }
}

module node_retention_section(variant = 0) {
    base_z = node_example_receiver_base_z(variant);

    color([0.68, 0.70, 0.74])
        node_receiver_retention_profile(variant);

    translate([0, 0, base_z + NODE_SNAP_SEATED_Z])
        color([0.92, 0.30, 0.12])
            node_snap_retention_profile();
}

module node_transition_section(variant = 0) {
    color([0.68, 0.70, 0.74])
        node_receiver_transition_profile(variant);
}

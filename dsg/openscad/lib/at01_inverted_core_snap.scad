// SPDX-License-Identifier: CC-BY-NC-SA-4.0
//
// This file contains experiment geometry derived from the OpenGrid/QuackWorks
// reference. Original OpenGrid design: David D.
// QuackWorks/OpenSCAD reference: AndyLevesque/QuackWorks,
// pinned at e0c1cb7ec78dd9e9a8476ed739bd3402074354f3.
// See LICENSE and docs/00-source-provenance.md for attribution and provenance.
//
// // File: at01_inverted_core_snap.scad
// AT-01 — two fixed-receiver carrier concepts with one shared removable snap.
//
// The local X/Z mating profile is intentionally derived from the QuackWorks
// OpenGrid Lite receiver + normal snap relationship at:
//   AndyLevesque/QuackWorks
//   e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
//
// Roles are inverted radially:
//   OpenGrid receiver inner wall -> AT-01 fixed receiver outer wall
//   OpenGrid snap outward nub    -> AT-01 removable snap inward nub
//
// The receiver is LOCAL: one 10 x 10 mm attachment zone in the middle of each
// 50 mm carrier. Only the two +/-X sides retain/flex. The snap is open at both
// Y ends and clips on locally from above.

// BOSL2 is used for rounded click-slot cuts.
include <BOSL2/std.scad>

// Carrier dimensions.
AT01_CARRIER_LENGTH = 50.0;

AT01_RAIL_WIDTH = 10.0;
AT01_RAIL_HEIGHT = 4.0;

AT01_PLATE_WIDTH = 20.0;
AT01_PLATE_HEIGHT = 6.0;

// Local receiver footprint along the carrier.
AT01_RECEIVER_ZONE_LENGTH = 10.0;
AT01_RECEIVER_TRANSITION = 1.0;
AT01_RECEIVER_ACTIVE_LENGTH =
    AT01_RECEIVER_ZONE_LENGTH - 2 * AT01_RECEIVER_TRANSITION; // 8 mm

// The upper insertion guide needs a visibly longer end taper than the lower
// receiver profile. Otherwise the X/Z lead-in simply appears to terminate in
// a vertical cut. Keep the lower transition at 1 mm, but give the top guide
// 2 mm per end so it reads and behaves as a real centring funnel.
AT01_RECEIVER_TOP_TRANSITION = 2.0;
AT01_RECEIVER_TOP_ACTIVE_LENGTH =
    AT01_RECEIVER_ZONE_LENGTH - 2 * AT01_RECEIVER_TOP_TRANSITION; // 6 mm

// Plate-only straight support around the same 10 mm functional receiver.
// The extra 2 mm at each Y end is ordinary 10 x 4 mm material, not part of
// the snap interface.
AT01_PLATE_SUPPORT_LENGTH = 14.0;
AT01_PLATE_SUPPORT_END = 2.0;

// Shared receiver X/Z dimensions.
AT01_RECEIVER_MAX_WIDTH = 10.0;
AT01_RECEIVER_HEIGHT = 4.0;

// Removable snap length matches the local receiver footprint.
AT01_SNAP_LENGTH = 10.0;

// OpenGrid Lite source dimensions used by the radial mirror.
AT01_SOURCE_RECEIVER_NARROW = 25.0;
AT01_SOURCE_RECEIVER_WIDE = 26.4;
AT01_SOURCE_RECEIVER_TOP = 25.8;
AT01_SOURCE_SNAP_BODY = 24.8;
AT01_SOURCE_SNAP_NUB = 25.6;

// Mirror constant: original narrow 25 mm opening becomes 10 mm fixed capture.
AT01_RADIAL_MIRROR_SUM =
    AT01_SOURCE_RECEIVER_NARROW + AT01_RECEIVER_MAX_WIDTH;

// Mirrored fixed-receiver profile widths.
AT01_RECEIVER_LOWER_WIDTH =
    AT01_RADIAL_MIRROR_SUM - AT01_SOURCE_RECEIVER_WIDE; // 8.6
AT01_RECEIVER_TOP_WIDTH =
    AT01_RADIAL_MIRROR_SUM - AT01_SOURCE_RECEIVER_TOP;  // 9.2
AT01_RECEIVER_TOP_LENGTH = AT01_RECEIVER_TOP_WIDTH;     // four-sided lead-in

// Mirrored snap inner widths.
AT01_SNAP_INNER_WIDTH =
    AT01_RADIAL_MIRROR_SUM - AT01_SOURCE_SNAP_BODY;     // 10.2
AT01_SNAP_NUB_OPENING =
    AT01_RADIAL_MIRROR_SUM - AT01_SOURCE_SNAP_NUB;      // 9.4
AT01_NUB_PROTRUSION =
    (AT01_SNAP_INNER_WIDTH - AT01_SNAP_NUB_OPENING) / 2; // 0.4

// Lite receiver X/Z profile after taking the upper 4.0 mm of the Full board.
// Radially mirrored fixed receiver:
//   z 0.0 .. 1.6   width 8.6
//   z 1.6 .. 2.6   ramp 8.6 -> 10.0
//   z 2.6 .. 3.6   width 10.0
//   z 3.6 .. 4.0   ramp 10.0 -> 9.2
AT01_RECEIVER_LOWER_Z = 1.6;
AT01_RECEIVER_RAMP_TOP_Z = 2.6;
AT01_RECEIVER_CAPTURE_TOP_Z = 3.6;

// Lite snap seated top-flush against the 4 mm receiver.
AT01_SNAP_SEATED_Z = 0.6;
AT01_SNAP_ENGAGEMENT_HEIGHT = 3.4;

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
AT01_FLEX_TONGUE = 0.7;
AT01_CLICK_SLOT_RADIAL = 0.6;
AT01_CLICK_SLOT_ROUNDING = 0.3;
AT01_OUTER_SUPPORT = 0.7;

AT01_SNAP_WALL =
    AT01_FLEX_TONGUE + AT01_CLICK_SLOT_RADIAL + AT01_OUTER_SUPPORT; // 2.0
AT01_SNAP_TOP = 1.2;
AT01_SNAP_OUTER_WIDTH = AT01_SNAP_INNER_WIDTH + 2 * AT01_SNAP_WALL;
AT01_SNAP_TOTAL_HEIGHT = AT01_SNAP_ENGAGEMENT_HEIGHT + AT01_SNAP_TOP;

// Normal OpenGrid snap nub dimensions, radially mirrored.
// Z/radial dimensions stay at upstream values; tangential length scales with
// the 25 -> 10 mm receiver width reduction.
AT01_PLAN_SCALE =
    AT01_RECEIVER_MAX_WIDTH / AT01_SOURCE_RECEIVER_NARROW; // 0.4

// OpenGrid uses a chamfered/rounded plan form on the snap top rather than a
// plain rectangular slab. Scale the source 3.262743 mm plan rounding with the
// same 25 -> 10 mm reduction used for tangential dimensions.
AT01_SOURCE_CORE_ROUNDING = 4.81837;
AT01_SOURCE_TOP_ROUNDING = 3.262743;
// A direct 25 -> 10 mm scale gives ~1.93 mm, which consumes almost the entire
// 2.0 mm wall at the open end. Keep the source 45-degree corner language, but
// cap the reduced chamfer at half the wall thickness so the end retains a
// visible straight segment as well.
AT01_SNAP_CORE_ROUNDING = min(
    AT01_SOURCE_CORE_ROUNDING * AT01_PLAN_SCALE,
    AT01_SNAP_WALL / 2
);

// Keep one coherent outer plan contour: top and core use the same chamfer.
AT01_SNAP_TOP_ROUNDING = AT01_SNAP_CORE_ROUNDING;

// OpenGrid click-hole proportions retained on +/-X only.
// Radial width and rounding are source values. Tangential length is shortened
// for this 10 mm coupon while preserving the 11/12.4 nub/slot relationship.
AT01_CLICK_SLOT_LENGTH_Y = 12.4 * AT01_PLAN_SCALE;         // 4.96
AT01_CLICK_SLOT_HEIGHT = 1.5;
AT01_CLICK_SLOT_X_FROM_INNER =
    AT01_FLEX_TONGUE + AT01_CLICK_SLOT_RADIAL / 2;          // 1.0

AT01_TOP_SLOT_RADIAL = 1.4;
AT01_TOP_SLOT_LENGTH_Y = 12.0 * AT01_PLAN_SCALE;           // 4.8
AT01_TOP_SLOT_HEIGHT = 0.4;
AT01_TOP_SLOT_Z = 2.2;

// Evidence helpers.
AT01_EXPLODED_Z = 8.0;
AT01_PROFILE_SLICE = 1.0;
AT01_TRANSITION_PLAN_Z = 0.8;

// Optional physical millimetre reference grooves.
// These are real subtractive features so they appear in STL as well as render.
// The reference is deliberately compact: one centred 10 x 10 mm "centimetre"
// patch, rather than a grid spread over the complete receiver/support area.
AT01_MM_PATTERN_PITCH = 1.0;
AT01_MM_PATTERN_DEPTH = 0.12;
AT01_MM_PATTERN_LINE_WIDTH = 0.12;
AT01_MM_PATTERN_TICK_LENGTH = 0.55;
AT01_MM_PATTERN_TICK_WIDTH = 0.10;

// Invariants.
assert(abs(AT01_RECEIVER_LOWER_WIDTH - 8.6) < 0.0001);
assert(abs(AT01_RECEIVER_TOP_WIDTH - 9.2) < 0.0001);
assert(abs(AT01_RECEIVER_TOP_LENGTH - 9.2) < 0.0001);
assert(abs(AT01_SNAP_INNER_WIDTH - 10.2) < 0.0001);
assert(abs(AT01_SNAP_NUB_OPENING - 9.4) < 0.0001);
assert(abs(AT01_NUB_PROTRUSION - 0.4) < 0.0001);
assert(abs(AT01_FLEX_TONGUE - 0.7) < 0.0001);
assert(abs(AT01_CLICK_SLOT_RADIAL - 0.6) < 0.0001);
assert(abs(AT01_CLICK_SLOT_ROUNDING - 0.3) < 0.0001);
assert(abs(AT01_SNAP_WALL - 2.0) < 0.0001);
assert(abs(AT01_SNAP_CORE_ROUNDING - AT01_SNAP_TOP_ROUNDING) < 0.0001);
assert(abs(AT01_SNAP_CORE_ROUNDING - AT01_SNAP_WALL / 2) < 0.0001);
assert(AT01_SNAP_CORE_ROUNDING < AT01_SNAP_LENGTH / 2);
assert(abs(AT01_RECEIVER_ZONE_LENGTH - 10.0) < 0.0001);
assert(abs(AT01_RECEIVER_TRANSITION - 1.0) < 0.0001);
assert(abs(AT01_RECEIVER_ACTIVE_LENGTH - 8.0) < 0.0001);
assert(abs(AT01_RECEIVER_TOP_TRANSITION - 2.0) < 0.0001);
assert(abs(AT01_RECEIVER_TOP_ACTIVE_LENGTH - 6.0) < 0.0001);
assert(abs(AT01_PLATE_SUPPORT_LENGTH - 14.0) < 0.0001);
assert(abs(AT01_PLATE_SUPPORT_END - 2.0) < 0.0001);
assert(abs(AT01_SNAP_SEATED_Z + AT01_SNAP_ENGAGEMENT_HEIGHT - AT01_RECEIVER_HEIGHT) < 0.0001);

// --- Shared receiver profiling by subtractive side cuts ---------------------
//
// Start from an ordinary straight 10 x 4 mm carrier/support. The receiver is
// created only by removing the two source-derived side recesses:
//
//   lower recess: x 4.3..5.0 over z 0..2.6 with the 1.6..2.6 ramp
//   top recess:   triangular x 4.6..5.0 over z 3.6..4.0
//
// In the central 8 mm these cuts are constant. Over the last 1 mm at each Y
// end their radial depth tapers explicitly to zero. The opposite X and Y sides
// are generated by mirror(), guaranteeing geometric symmetry. No hull() and no
// non-planar ruled quads are used.

module _at01_positive_x_lower_cut_active() {
    rotate([90, 0, 0])
        linear_extrude(
            height = AT01_RECEIVER_ACTIVE_LENGTH,
            center = true,
            convexity = 10
        )
            polygon(points = [
                [AT01_RECEIVER_LOWER_WIDTH / 2, 0],
                [AT01_RAIL_WIDTH / 2 + 0.01, 0],
                [AT01_RAIL_WIDTH / 2 + 0.01, AT01_RECEIVER_RAMP_TOP_Z],
                [AT01_RECEIVER_LOWER_WIDTH / 2, AT01_RECEIVER_LOWER_Z]
            ]);
}

module _at01_positive_x_top_cut_active() {
    // Keep the full X/Z lead-in over the central top-guide length only.
    // The last 2 mm at each Y end are handled by an explicit taper below so
    // the sloped face does not terminate in a vertical wall.
    rotate([90, 0, 0])
        linear_extrude(
            height = AT01_RECEIVER_TOP_ACTIVE_LENGTH,
            center = true,
            convexity = 10
        )
            polygon(points = [
                [AT01_RECEIVER_TOP_WIDTH / 2, AT01_RECEIVER_HEIGHT + 0.01],
                [AT01_RAIL_WIDTH / 2 + 0.01, AT01_RECEIVER_HEIGHT + 0.01],
                [AT01_RAIL_WIDTH / 2 + 0.01, AT01_RECEIVER_CAPTURE_TOP_Z]
            ]);
}

// Positive-Y transition for the X-side top lead-in.
//
// At Y=active_half this is the same triangular X/Z cut as the central lead-in.
// Over the final 2 mm the complete triangle collapses into the ordinary rail
// edge. The transition therefore slopes in Z as well as in plan view and does
// not terminate the lead-in with a vertical wall.
module _at01_positive_y_top_cut_transition() {
    ya = AT01_RECEIVER_TOP_ACTIVE_LENGTH / 2;
    yb = AT01_RECEIVER_ZONE_LENGTH / 2;
    xi = AT01_RECEIVER_TOP_WIDTH / 2;
    xo = AT01_RAIL_WIDTH / 2 + 0.01;
    z0 = AT01_RECEIVER_CAPTURE_TOP_Z;
    z1 = AT01_RECEIVER_HEIGHT + 0.01;

    // Start with the same triangular X/Z lead-in section as the active
    // centre. Over the 2 mm Y transition, collapse that complete triangle to
    // the ORIGINAL outer/top rail corner. That is the zero-cut condition.
    //
    // The exposed chamfer face therefore continues as a genuine 3D guide
    // surface into the ordinary rail instead of appearing to terminate
    // against a straight end wall.
    polyhedron(
        points = [
            [xi, ya, z1],
            [xo, ya, z1],
            [xo, ya, z0],
            [xo, yb, z1]
        ],
        faces = [
            [0, 2, 1],
            [0, 1, 3],
            [1, 2, 3],
            [2, 0, 3]
        ],
        convexity = 10
    );
}

// Positive-Y lower cut taper.
// At Y=active_half it has the full receiver cutout. At Y=zone_half it has
// zero radial depth at X=5, so the carrier is exactly rectangular again.
module _at01_positive_y_lower_cut_transition() {
    ya = AT01_RECEIVER_ACTIVE_LENGTH / 2;
    yb = AT01_RECEIVER_ZONE_LENGTH / 2;
    xi = AT01_RECEIVER_LOWER_WIDTH / 2;
    xo = AT01_RAIL_WIDTH / 2 + 0.01;

    polyhedron(
        points = [
            [xi, ya, 0],
            [xo, ya, 0],
            [xo, ya, AT01_RECEIVER_RAMP_TOP_Z],
            [xi, ya, AT01_RECEIVER_LOWER_Z],
            [xo, yb, 0],
            [xo, yb, AT01_RECEIVER_RAMP_TOP_Z]
        ],
        faces = [
            [0, 1, 2, 3],
            [0, 4, 1],
            [1, 4, 5, 2],
            [2, 5, 3],
            [3, 5, 4, 0]
        ],
        convexity = 10
    );
}

// Positive-Y top lead-in cut.
//
// The local receiver's top footprint must help centre a part pressed down from
// above. At Z=3.6 the receiver still reaches Y=5.0; at Z=4.0 the top edge has
// moved inward to Y=4.6. Material outside Y=5 belongs to the surrounding
// rail/support, leaving a small V-like separation at the receiver boundary.
module _at01_positive_y_top_leadin_cut() {
    xi = AT01_RAIL_WIDTH / 2 + 0.01;
    yi = AT01_RECEIVER_TOP_LENGTH / 2;
    yo = AT01_RECEIVER_ZONE_LENGTH / 2 + 0.01;
    z0 = AT01_RECEIVER_CAPTURE_TOP_Z;
    z1 = AT01_RECEIVER_HEIGHT + 0.01;

    polyhedron(
        points = [
            [-xi, yi, z1],
            [ xi, yi, z1],
            [-xi, yo, z1],
            [ xi, yo, z1],
            [-xi, yo, z0],
            [ xi, yo, z0]
        ],
        faces = [
            [0, 2, 4],
            [1, 5, 3],
            [0, 1, 3, 2],
            [2, 3, 5, 4],
            [4, 5, 1, 0]
        ],
        convexity = 10
    );
}

module _at01_positive_x_receiver_cuts() {
    union() {
        _at01_positive_x_lower_cut_active();
        _at01_positive_x_top_cut_active();

        _at01_positive_y_lower_cut_transition();
        _at01_positive_y_top_cut_transition();

        mirror([0, 1, 0]) {
            _at01_positive_y_lower_cut_transition();
            _at01_positive_y_top_cut_transition();
        }
    }
}

module _at01_receiver_cuts() {
    union() {
        _at01_positive_x_receiver_cuts();

        mirror([1, 0, 0])
            _at01_positive_x_receiver_cuts();

        _at01_positive_y_top_leadin_cut();

        mirror([0, 1, 0])
            _at01_positive_y_top_leadin_cut();
    }
}

// --- Optional physical millimetre reference pattern ------------------------

module _at01_mm_reference_cuts_at_top(top_z, x_length, y_length) {
    z_center =
        top_z - AT01_MM_PATTERN_DEPTH / 2 + 0.01;

    // Let the two main grooves run all the way to the real part boundary.
    // A tiny overrun guarantees the subtraction reaches the outside face;
    // intersection with the part naturally clips chamfered outlines.
    translate([0, 0, z_center])
        cube([
            x_length + 0.02,
            AT01_MM_PATTERN_LINE_WIDTH,
            AT01_MM_PATTERN_DEPTH + 0.02
        ], center = true);

    translate([0, 0, z_center])
        cube([
            AT01_MM_PATTERN_LINE_WIDTH,
            y_length + 0.02,
            AT01_MM_PATTERN_DEPTH + 0.02
        ], center = true);

    // 1 mm ticks continue over the available line length. The owning part
    // clips ticks automatically at chamfers and outer boundaries.
    x_tick_max = floor(x_length / 2 / AT01_MM_PATTERN_PITCH);
    y_tick_max = floor(y_length / 2 / AT01_MM_PATTERN_PITCH);

    for (i = [-x_tick_max : 1 : x_tick_max])
        if (i != 0)
            translate([i * AT01_MM_PATTERN_PITCH, 0, z_center])
                cube([
                    AT01_MM_PATTERN_TICK_WIDTH,
                    AT01_MM_PATTERN_TICK_LENGTH,
                    AT01_MM_PATTERN_DEPTH + 0.02
                ], center = true);

    for (i = [-y_tick_max : 1 : y_tick_max])
        if (i != 0)
            translate([0, i * AT01_MM_PATTERN_PITCH, z_center])
                cube([
                    AT01_MM_PATTERN_TICK_LENGTH,
                    AT01_MM_PATTERN_TICK_WIDTH,
                    AT01_MM_PATTERN_DEPTH + 0.02
                ], center = true);
}

// --- Carrier A: 50 x 10 x 4 rail with one local receiver zone --------------

module _at01_receiver_rail_geometry() {
    difference() {
        translate([
            -AT01_RAIL_WIDTH / 2,
            -AT01_CARRIER_LENGTH / 2,
            0
        ])
            cube([
                AT01_RAIL_WIDTH,
                AT01_CARRIER_LENGTH,
                AT01_RAIL_HEIGHT
            ]);

        _at01_receiver_cuts();
    }
}

module at01_receiver_rail(mm_pattern = false) {
    difference() {
        _at01_receiver_rail_geometry();

        if (mm_pattern)
            _at01_mm_reference_cuts_at_top(
                AT01_RECEIVER_HEIGHT,
                AT01_RAIL_WIDTH,
                AT01_CARRIER_LENGTH
            );
    }
}

// --- Carrier B: 50 x 20 x 6 plate + 10 x 14 x 4 support boss --------------

module _at01_receiver_plate_geometry() {
    union() {
        translate([
            -AT01_PLATE_WIDTH / 2,
            -AT01_CARRIER_LENGTH / 2,
            0
        ])
            cube([
                AT01_PLATE_WIDTH,
                AT01_CARRIER_LENGTH,
                AT01_PLATE_HEIGHT
            ]);

        translate([0, 0, AT01_PLATE_HEIGHT])
            difference() {
                translate([
                    -AT01_RAIL_WIDTH / 2,
                    -AT01_PLATE_SUPPORT_LENGTH / 2,
                    0
                ])
                    cube([
                        AT01_RAIL_WIDTH,
                        AT01_PLATE_SUPPORT_LENGTH,
                        AT01_RECEIVER_HEIGHT
                    ]);

                _at01_receiver_cuts();
            }
    }
}

module at01_receiver_plate(mm_pattern = false) {
    difference() {
        _at01_receiver_plate_geometry();

        if (mm_pattern)
            _at01_mm_reference_cuts_at_top(
                AT01_PLATE_HEIGHT + AT01_RECEIVER_HEIGHT,
                AT01_RAIL_WIDTH,
                AT01_PLATE_SUPPORT_LENGTH
            );
    }
}

function at01_receiver_base_z(variant) =
    variant == 0 ? 0 : AT01_PLATE_HEIGHT;

module at01_receiver(variant = 0, mm_pattern = false) {
    assert(variant == 0 || variant == 1, "AT-01 receiver variant must be 0 or 1.");

    if (variant == 0)
        at01_receiver_rail(mm_pattern);
    else
        at01_receiver_plate(mm_pattern);
}

// --- Shared removable snap -------------------------------------------------

module _at01_snap_core_outer_envelope() {
    // QuackWorks forms the Lite core with a chamfered plan outline:
    // cuboid(... rounding=4.81837, edges="Z", $fn=2).
    //
    // Keep that plan-form logic under the 25 -> 10 mm reduction so the
    // reduced snap has the same recognisable clipped-corner silhouette.
    cuboid(
        [
            AT01_SNAP_OUTER_WIDTH,
            AT01_SNAP_LENGTH,
            AT01_SNAP_ENGAGEMENT_HEIGHT
        ],
        rounding = AT01_SNAP_CORE_ROUNDING,
        edges = "Z",
        $fn = 2,
        anchor = BOTTOM
    );
}

module _at01_snap_side_wall(x_sign = 1) {
    inner = AT01_SNAP_INNER_WIDTH / 2;
    outer = AT01_SNAP_OUTER_WIDTH / 2;

    intersection() {
        translate([
            x_sign * (inner + outer) / 2,
            0,
            AT01_SNAP_ENGAGEMENT_HEIGHT / 2
        ])
            cube([
                AT01_SNAP_WALL,
                AT01_SNAP_LENGTH,
                AT01_SNAP_ENGAGEMENT_HEIGHT
            ], center = true);

        _at01_snap_core_outer_envelope();
    }
}

module _at01_snap_top() {
    translate([
        0,
        0,
        AT01_SNAP_ENGAGEMENT_HEIGHT + AT01_SNAP_TOP / 2
    ])
        cuboid(
            [
                AT01_SNAP_OUTER_WIDTH,
                AT01_SNAP_LENGTH,
                AT01_SNAP_TOP
            ],
            rounding = AT01_SNAP_TOP_ROUNDING,
            edges = "Z",
            $fn = 2,
            anchor = CENTER
        );
}

// Exact radial/Z construction used by the normal QuackWorks OpenGrid nub,
// expressed in local coordinates with the snap body face at X=0.
//
// AT-01 deliberately does NOT replace this with a simple trapezoid: that older
// reduction created the visually wrong straight middle section. The PoP keeps
// the source 0.4 mm radial depth and 0.2/0.6/0.6 mm Z wedge relationship, then
// scales only the tangential Y direction by AT01_PLAN_SCALE.
module _at01_source_nub_local() {
    source_nub_h = 0.2;
    source_nub_w = 11.0;
    source_nub_d = 0.4;
    source_top_wedge_h = 0.6;
    source_bottom_wedge_h = 0.6;
    source_round_x = -12.36;
    source_round_scale_y = 1.36;
    source_round_r = 13.025;

    intersection() {
        difference() {
            translate([0, 0, source_nub_h - 0.01])
                cuboid(
                    [
                        source_nub_d,
                        source_nub_w,
                        2.0 - source_nub_h + 0.01
                    ],
                    anchor = CENTER + LEFT + BOTTOM
                );

            translate([0, 0, 2.0])
                rotate([0, 180, 90])
                    wedge(
                        [source_nub_w, source_nub_d, source_top_wedge_h],
                        anchor = CENTER + BOTTOM + BACK
                    );

            translate([0, 0, source_nub_h])
                rotate([0, 0, 90])
                    wedge(
                        [source_nub_w, 0.4, source_bottom_wedge_h],
                        anchor = CENTER + BOTTOM + BACK
                    );
        }

        translate([source_round_x, 0, 0])
            scale([1, source_round_scale_y, 1])
                cyl($fn = 180, r = source_round_r, h = 2.01, anchor = BOTTOM);
    }
}

module _at01_positive_x_nub() {
    inner = AT01_SNAP_INNER_WIDTH / 2;

    // The upstream nub grows outward from the body face. Mirror that radial
    // direction so it grows inward into the AT-01 snap opening. Scale only Y.
    translate([inner + 0.01, 0, 0])
        mirror([1, 0, 0])
            scale([1, AT01_PLAN_SCALE, 1])
                _at01_source_nub_local();
}

module _at01_positive_x_click_slot() {
    inner = AT01_SNAP_INNER_WIDTH / 2;

    translate([
        inner + AT01_CLICK_SLOT_X_FROM_INNER,
        0,
        AT01_CLICK_SLOT_HEIGHT / 2
    ])
        cuboid(
            [
                AT01_CLICK_SLOT_RADIAL,
                AT01_CLICK_SLOT_LENGTH_Y,
                AT01_CLICK_SLOT_HEIGHT
            ],
            rounding = AT01_CLICK_SLOT_ROUNDING,
            edges = "Z",
            anchor = CENTER
        );
}

module _at01_positive_x_top_slot() {
    inner = AT01_SNAP_INNER_WIDTH / 2;

    translate([
        inner,
        0,
        AT01_TOP_SLOT_Z + AT01_TOP_SLOT_HEIGHT / 2
    ])
        cube([
            AT01_TOP_SLOT_RADIAL,
            AT01_TOP_SLOT_LENGTH_Y,
            AT01_TOP_SLOT_HEIGHT
        ], center = true);
}

module at01_removable_snap(mm_pattern = false) {
    difference() {
        union() {
            _at01_snap_side_wall(1);
            _at01_snap_side_wall(-1);
            _at01_snap_top();

            _at01_positive_x_nub();

            mirror([1, 0, 0])
                _at01_positive_x_nub();
        }

        _at01_positive_x_click_slot();
        _at01_positive_x_top_slot();

        mirror([1, 0, 0]) {
            _at01_positive_x_click_slot();
            _at01_positive_x_top_slot();
        }

        if (mm_pattern)
            _at01_mm_reference_cuts_at_top(
                AT01_SNAP_TOTAL_HEIGHT,
                AT01_SNAP_OUTER_WIDTH,
                AT01_SNAP_LENGTH
            );
    }
}

// --- Assemblies ------------------------------------------------------------

module at01_assembled(variant = 0, snap_alpha = 0.55, mm_pattern = false) {
    base_z = at01_receiver_base_z(variant);

    color([0.68, 0.70, 0.74])
        at01_receiver(variant, mm_pattern);

    translate([0, 0, base_z + AT01_SNAP_SEATED_Z])
        color([0.92, 0.30, 0.12, snap_alpha])
            at01_removable_snap(mm_pattern);
}

module at01_exploded(variant = 0, mm_pattern = false) {
    base_z = at01_receiver_base_z(variant);

    color([0.68, 0.70, 0.74])
        at01_receiver(variant, mm_pattern);

    translate([
        0,
        0,
        base_z + AT01_SNAP_SEATED_Z + AT01_EXPLODED_Z
    ])
        color([0.92, 0.30, 0.12])
            at01_removable_snap(mm_pattern);
}

module at01_concepts_comparison(mm_pattern = false) {
    translate([-16, 0, 0])
        at01_assembled(0, mm_pattern = mm_pattern);

    translate([16, 0, 0])
        at01_assembled(1, mm_pattern = mm_pattern);
}

// --- Evidence sections -----------------------------------------------------

module _at01_y_slice() {
    translate([-30, -AT01_PROFILE_SLICE / 2, -1])
        cube([60, AT01_PROFILE_SLICE, 20]);
}

module _at01_transition_plan_slice(variant = 0) {
    base_z = at01_receiver_base_z(variant);

    // A horizontal 1 mm slice entirely inside the receiver's lower constant-
    // width band (0 .. 1.6 mm local Z). This exposes the Y lead-in/lead-out
    // directly in plan view without the misleading near-edge X/Z cut.
    translate([
        -30,
        -30,
        base_z + AT01_TRANSITION_PLAN_Z - AT01_PROFILE_SLICE / 2
    ])
        cube([60, 60, AT01_PROFILE_SLICE]);
}

module at01_receiver_retention_profile(variant = 0) {
    intersection() {
        at01_receiver(variant);
        _at01_y_slice();
    }
}

module at01_snap_retention_profile() {
    intersection() {
        at01_removable_snap();
        _at01_y_slice();
    }
}

module at01_receiver_transition_profile(variant = 0) {
    intersection() {
        at01_receiver(variant);
        _at01_transition_plan_slice(variant);
    }
}

module at01_retention_section(variant = 0) {
    base_z = at01_receiver_base_z(variant);

    color([0.68, 0.70, 0.74])
        at01_receiver_retention_profile(variant);

    translate([0, 0, base_z + AT01_SNAP_SEATED_Z])
        color([0.92, 0.30, 0.12])
            at01_snap_retention_profile();
}

module at01_transition_section(variant = 0) {
    color([0.68, 0.70, 0.74])
        at01_receiver_transition_profile(variant);
}

// File: at01_inverted_core_snap.scad
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
// Only the two +/-X sides retain/flex. Along Y the receiver is a continuous
// 50 mm rail and the removable snap is open-ended so it can clip on locally
// from above rather than sliding in from a rail end.

include <BOSL2/std.scad>

// Carrier concepts.
AT01_RECEIVER_LENGTH = 50.0;
AT01_RECEIVER_MAX_WIDTH = 10.0;
AT01_RECEIVER_HEIGHT = 4.0;

AT01_PLATE_LENGTH = 50.0;
AT01_PLATE_WIDTH = 20.0;
AT01_PLATE_HEIGHT = 6.0;

// Removable snap length along the rail.
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

// The Lite snap is 3.4 mm high and is used top-flush with the 4.0 mm Lite
// receiver. The snap-mount-generator places its functional base directly on the
// snap top, supporting this 0.6 mm seated bottom offset.
AT01_SNAP_SEATED_Z = 0.6;
AT01_SNAP_ENGAGEMENT_HEIGHT = 3.4;

// Experiment-owned outer snap wall/top dimensions. The mating inner profile
// remains source-derived; these values only provide printable surrounding mass.
AT01_SNAP_WALL = 2.0;
AT01_SNAP_TOP = 1.2;
AT01_SNAP_OUTER_WIDTH = AT01_SNAP_INNER_WIDTH + 2 * AT01_SNAP_WALL;
AT01_SNAP_TOTAL_HEIGHT = AT01_SNAP_ENGAGEMENT_HEIGHT + AT01_SNAP_TOP;

// Normal OpenGrid snap nub dimensions, radially mirrored.
// Z/radial dimensions stay at upstream values; tangential length scales with
// the 25 -> 10 mm receiver width reduction.
AT01_PLAN_SCALE =
    AT01_RECEIVER_MAX_WIDTH / AT01_SOURCE_RECEIVER_NARROW; // 0.4

AT01_NUB_LENGTH_Y = 11.0 * AT01_PLAN_SCALE;               // 4.4
AT01_NUB_Z_BOTTOM = 0.2;
AT01_NUB_Z_INWARD_START = 0.8;                             // +0.6 wedge
AT01_NUB_Z_INWARD_END = 1.4;
AT01_NUB_Z_TOP = 2.0;                                      // +0.6 wedge

// OpenGrid click-hole proportions retained on +/-X only.
AT01_CLICK_SLOT_RADIAL = 0.6;
AT01_CLICK_SLOT_LENGTH_Y = 12.4 * AT01_PLAN_SCALE;         // 4.96
AT01_CLICK_SLOT_HEIGHT = 1.5;
AT01_CLICK_SLOT_ROUNDING = 0.3;
AT01_CLICK_SLOT_X_FROM_INNER = 1.0;

AT01_TOP_SLOT_RADIAL = 1.4;
AT01_TOP_SLOT_LENGTH_Y = 12.0 * AT01_PLAN_SCALE;           // 4.8
AT01_TOP_SLOT_HEIGHT = 0.4;
AT01_TOP_SLOT_Z = 2.2;

// Evidence helpers.
AT01_EXPLODED_Z = 8.0;
AT01_PROFILE_SLICE = 1.0;

// Invariants.
assert(abs(AT01_RECEIVER_LOWER_WIDTH - 8.6) < 0.0001);
assert(abs(AT01_RECEIVER_TOP_WIDTH - 9.2) < 0.0001);
assert(abs(AT01_SNAP_INNER_WIDTH - 10.2) < 0.0001);
assert(abs(AT01_SNAP_NUB_OPENING - 9.4) < 0.0001);
assert(abs(AT01_NUB_PROTRUSION - 0.4) < 0.0001);
assert(abs(AT01_SNAP_SEATED_Z + AT01_SNAP_ENGAGEMENT_HEIGHT - AT01_RECEIVER_HEIGHT) < 0.0001);

// --- Shared fixed receiver profile -----------------------------------------

module _at01_receiver_profile_2d() {
    polygon(points = [
        [-AT01_RECEIVER_LOWER_WIDTH / 2, 0],
        [ AT01_RECEIVER_LOWER_WIDTH / 2, 0],
        [ AT01_RECEIVER_LOWER_WIDTH / 2, AT01_RECEIVER_LOWER_Z],
        [ AT01_RECEIVER_MAX_WIDTH / 2, AT01_RECEIVER_RAMP_TOP_Z],
        [ AT01_RECEIVER_MAX_WIDTH / 2, AT01_RECEIVER_CAPTURE_TOP_Z],
        [ AT01_RECEIVER_TOP_WIDTH / 2, AT01_RECEIVER_HEIGHT],
        [-AT01_RECEIVER_TOP_WIDTH / 2, AT01_RECEIVER_HEIGHT],
        [-AT01_RECEIVER_MAX_WIDTH / 2, AT01_RECEIVER_CAPTURE_TOP_Z],
        [-AT01_RECEIVER_MAX_WIDTH / 2, AT01_RECEIVER_RAMP_TOP_Z],
        [-AT01_RECEIVER_LOWER_WIDTH / 2, AT01_RECEIVER_LOWER_Z]
    ]);
}

module at01_receiver_rail() {
    rotate([90, 0, 0])
        linear_extrude(
            height = AT01_RECEIVER_LENGTH,
            center = true,
            convexity = 10
        )
            _at01_receiver_profile_2d();
}

module at01_receiver_plate() {
    union() {
        translate([
            -AT01_PLATE_WIDTH / 2,
            -AT01_PLATE_LENGTH / 2,
            0
        ])
            cube([
                AT01_PLATE_WIDTH,
                AT01_PLATE_LENGTH,
                AT01_PLATE_HEIGHT
            ]);

        translate([0, 0, AT01_PLATE_HEIGHT])
            at01_receiver_rail();
    }
}

function at01_receiver_base_z(variant) =
    variant == 0 ? 0 : AT01_PLATE_HEIGHT;

module at01_receiver(variant = 0) {
    assert(variant == 0 || variant == 1, "AT-01 receiver variant must be 0 or 1.");

    if (variant == 0)
        at01_receiver_rail();
    else
        at01_receiver_plate();
}

// --- Shared removable snap -------------------------------------------------

module _at01_snap_side_wall(x_sign = 1) {
    inner = AT01_SNAP_INNER_WIDTH / 2;
    outer = AT01_SNAP_OUTER_WIDTH / 2;

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
}

module _at01_snap_top() {
    translate([
        0,
        0,
        AT01_SNAP_ENGAGEMENT_HEIGHT + AT01_SNAP_TOP / 2
    ])
        cube([
            AT01_SNAP_OUTER_WIDTH,
            AT01_SNAP_LENGTH,
            AT01_SNAP_TOP
        ], center = true);
}

module _at01_positive_x_nub() {
    inner = AT01_SNAP_INNER_WIDTH / 2;

    rotate([90, 0, 0])
        linear_extrude(
            height = AT01_NUB_LENGTH_Y,
            center = true,
            convexity = 10
        )
            polygon(points = [
                [inner, AT01_NUB_Z_BOTTOM],
                [inner - AT01_NUB_PROTRUSION, AT01_NUB_Z_INWARD_START],
                [inner - AT01_NUB_PROTRUSION, AT01_NUB_Z_INWARD_END],
                [inner, AT01_NUB_Z_TOP]
            ]);
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

module at01_removable_snap() {
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
    }
}

// --- Assemblies ------------------------------------------------------------

module at01_assembled(variant = 0, snap_alpha = 0.55) {
    base_z = at01_receiver_base_z(variant);

    color([0.68, 0.70, 0.74])
        at01_receiver(variant);

    translate([0, 0, base_z + AT01_SNAP_SEATED_Z])
        color([0.92, 0.30, 0.12, snap_alpha])
            at01_removable_snap();
}

module at01_exploded(variant = 0) {
    base_z = at01_receiver_base_z(variant);

    color([0.68, 0.70, 0.74])
        at01_receiver(variant);

    translate([
        0,
        0,
        base_z + AT01_SNAP_SEATED_Z + AT01_EXPLODED_Z
    ])
        color([0.92, 0.30, 0.12])
            at01_removable_snap();
}

module at01_concepts_comparison() {
    translate([-16, 0, 0])
        at01_assembled(0);

    translate([16, 0, 0])
        at01_assembled(1);
}

// --- Evidence sections -----------------------------------------------------

module _at01_y_slice() {
    translate([-30, -AT01_PROFILE_SLICE / 2, -1])
        cube([60, AT01_PROFILE_SLICE, 20]);
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

module at01_retention_section(variant = 0) {
    base_z = at01_receiver_base_z(variant);

    color([0.68, 0.70, 0.74])
        at01_receiver_retention_profile(variant);

    translate([0, 0, base_z + AT01_SNAP_SEATED_Z])
        color([0.92, 0.30, 0.12])
            at01_snap_retention_profile();
}

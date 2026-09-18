// File: at01_inverted_core_snap.scad
// AT-01 — experiment-owned inverted fixed-core / removable-shell snap.
//
// The fixed part stays entirely inside a 10 x 10 x 4 mm envelope and carries
// inward retention grooves. All protruding snap geometry and intended flexure
// live on the removable outside shell.

// Fixed-side Lite-inspired baseline.
AT01_CORE_SIZE = 10.0;
AT01_CORE_HEIGHT = 4.0;
AT01_ROOT_SHOULDER = 0.6;
AT01_ENGAGEMENT_HEIGHT = 3.4;

// Removable shell.
AT01_CLEARANCE = 0.20;              // per side around nominal core
AT01_SHELL_WALL = 1.20;
AT01_SHELL_TOP = 1.20;
AT01_SHELL_INNER = AT01_CORE_SIZE + 2 * AT01_CLEARANCE;
AT01_SHELL_OUTER = AT01_SHELL_INNER + 2 * AT01_SHELL_WALL;
AT01_SHELL_HEIGHT = AT01_ENGAGEMENT_HEIGHT + AT01_SHELL_TOP;

// Fixed retention grooves on +/-X.
AT01_GROOVE_DEPTH = 0.40;
AT01_GROOVE_WIDTH = 4.40;
AT01_GROOVE_Z_MIN = 1.35;
AT01_GROOVE_Z_MAX = 2.15;

// Inward shell nubs on the two compliant +/-X tongues.
// Local shell coordinates; assembled shell bottom sits at ROOT_SHOULDER.
AT01_NUB_PROTRUSION = 0.35;
AT01_NUB_WIDTH = 4.00;
AT01_NUB_Z_BOTTOM = 0.75;
AT01_NUB_Z_MAX_IN = 1.10;
AT01_NUB_Z_RETENTION = 1.45;
AT01_NUB_Z_TOP = 1.55;

// Flex slots isolate a center tongue on each +/-X shell wall.
AT01_FLEX_SLOT_Y = 2.50;
AT01_FLEX_SLOT_WIDTH = 0.80;
AT01_FLEX_SLOT_HEIGHT = 2.80;

// Evidence helpers.
AT01_EXPLODED_Z = 8.0;
AT01_PROFILE_SLICE = 1.0;

assert(
    abs(AT01_ROOT_SHOULDER + AT01_ENGAGEMENT_HEIGHT - AT01_CORE_HEIGHT) < 0.0001,
    "AT-01 Lite baseline must satisfy shoulder + engagement = 4.0 mm."
);
assert(
    abs(AT01_SHELL_INNER - (AT01_CORE_SIZE + 2 * AT01_CLEARANCE)) < 0.0001,
    "AT-01 shell inner size must preserve the stated side clearance."
);
assert(
    AT01_NUB_PROTRUSION > AT01_CLEARANCE,
    "AT-01 inward nub must exceed nominal side clearance to create snap flex."
);
assert(
    AT01_GROOVE_DEPTH > (AT01_NUB_PROTRUSION - AT01_CLEARANCE),
    "AT-01 fixed groove must be deep enough for the seated inward nub."
);
assert(
    abs((AT01_ROOT_SHOULDER + AT01_NUB_Z_BOTTOM) - AT01_GROOVE_Z_MIN) < 0.0001,
    "AT-01 seated nub bottom must align with groove bottom."
);
assert(
    abs((AT01_ROOT_SHOULDER + AT01_NUB_Z_TOP) - AT01_GROOVE_Z_MAX) < 0.0001,
    "AT-01 seated nub top must align with groove top."
);

module _at01_positive_x_groove() {
    translate([
        AT01_CORE_SIZE / 2 - AT01_GROOVE_DEPTH / 2 + 0.01,
        0,
        (AT01_GROOVE_Z_MIN + AT01_GROOVE_Z_MAX) / 2
    ])
        cube([
            AT01_GROOVE_DEPTH + 0.02,
            AT01_GROOVE_WIDTH,
            AT01_GROOVE_Z_MAX - AT01_GROOVE_Z_MIN
        ], center = true);
}

module at01_fixed_core() {
    difference() {
        translate([-AT01_CORE_SIZE / 2, -AT01_CORE_SIZE / 2, 0])
            cube([AT01_CORE_SIZE, AT01_CORE_SIZE, AT01_CORE_HEIGHT]);

        _at01_positive_x_groove();

        mirror([1, 0, 0])
            _at01_positive_x_groove();
    }
}

module _at01_shell_outer() {
    translate([-AT01_SHELL_OUTER / 2, -AT01_SHELL_OUTER / 2, 0])
        cube([AT01_SHELL_OUTER, AT01_SHELL_OUTER, AT01_SHELL_HEIGHT]);
}

module _at01_shell_cavity() {
    // Open from the bottom and stop at the underside of the top plate.
    translate([-AT01_SHELL_INNER / 2, -AT01_SHELL_INNER / 2, -0.05])
        cube([
            AT01_SHELL_INNER,
            AT01_SHELL_INNER,
            AT01_ENGAGEMENT_HEIGHT + 0.05
        ]);
}

module _at01_positive_x_nub() {
    // X/Z profile extruded along Y.
    // During downward insertion the lower ramp meets the fixed-core top/side
    // first and deflects the tongue outward. The upper return is deliberately
    // steeper to provide retention during removal.
    inner_face = AT01_SHELL_INNER / 2;

    rotate([90, 0, 0])
        linear_extrude(height = AT01_NUB_WIDTH, center = true, convexity = 10)
            polygon(points = [
                [inner_face, AT01_NUB_Z_BOTTOM],
                [inner_face - AT01_NUB_PROTRUSION, AT01_NUB_Z_MAX_IN],
                [inner_face - AT01_NUB_PROTRUSION, AT01_NUB_Z_RETENTION],
                [inner_face, AT01_NUB_Z_TOP]
            ]);
}

module _at01_flex_slot(x_sign = 1, y_sign = 1) {
    wall_center =
        (AT01_SHELL_INNER / 2 + AT01_SHELL_OUTER / 2) / 2;

    translate([
        x_sign * wall_center,
        y_sign * AT01_FLEX_SLOT_Y,
        AT01_FLEX_SLOT_HEIGHT / 2 - 0.05
    ])
        cube([
            AT01_SHELL_WALL + 0.4,
            AT01_FLEX_SLOT_WIDTH,
            AT01_FLEX_SLOT_HEIGHT + 0.10
        ], center = true);
}

module at01_removable_shell() {
    union() {
        difference() {
            _at01_shell_outer();
            _at01_shell_cavity();

            for (x_sign = [-1, 1])
                for (y_sign = [-1, 1])
                    _at01_flex_slot(x_sign, y_sign);
        }

        _at01_positive_x_nub();

        mirror([1, 0, 0])
            _at01_positive_x_nub();
    }
}

module at01_assembled(shell_alpha = 0.55) {
    color([0.68, 0.70, 0.74])
        at01_fixed_core();

    translate([0, 0, AT01_ROOT_SHOULDER])
        color([0.92, 0.30, 0.12, shell_alpha])
            at01_removable_shell();
}

module at01_exploded() {
    color([0.68, 0.70, 0.74])
        at01_fixed_core();

    translate([0, 0, AT01_ROOT_SHOULDER + AT01_EXPLODED_Z])
        color([0.92, 0.30, 0.12])
            at01_removable_shell();
}

module _at01_retention_slice_volume() {
    translate([-20, -AT01_PROFILE_SLICE / 2, -1])
        cube([40, AT01_PROFILE_SLICE, 12]);
}

module _at01_locating_slice_volume() {
    translate([-AT01_PROFILE_SLICE / 2, -20, -1])
        cube([AT01_PROFILE_SLICE, 40, 12]);
}

module at01_fixed_retention_profile() {
    intersection() {
        at01_fixed_core();
        _at01_retention_slice_volume();
    }
}

module at01_shell_retention_profile() {
    intersection() {
        at01_removable_shell();
        translate([0, 0, -AT01_ROOT_SHOULDER])
            _at01_retention_slice_volume();
    }
}

module at01_fixed_locating_profile() {
    intersection() {
        at01_fixed_core();
        _at01_locating_slice_volume();
    }
}

module at01_shell_locating_profile() {
    intersection() {
        at01_removable_shell();
        translate([0, 0, -AT01_ROOT_SHOULDER])
            _at01_locating_slice_volume();
    }
}

module at01_retention_section() {
    color([0.68, 0.70, 0.74])
        at01_fixed_retention_profile();

    translate([0, 0, AT01_ROOT_SHOULDER])
        color([0.92, 0.30, 0.12])
            at01_shell_retention_profile();
}

module at01_locating_section() {
    color([0.68, 0.70, 0.74])
        at01_fixed_locating_profile();

    translate([0, 0, AT01_ROOT_SHOULDER])
        color([0.92, 0.30, 0.12])
            at01_shell_locating_profile();
}
